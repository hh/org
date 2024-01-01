+++
title = "Rerouting Container Registries With Envoy"
author = ["Caleb Woodbine"]
date = 2021-04-15
lastmod = 2021-04-21T15:44:52+12:00
tags = ["envoy", "oci", "containers", "discoveries"]
categories = ["discoveries"]
draft = false
weight = 2001
summary = "Share the traffic across many container registries with Envoy"
+++

## Introduction {#introduction}

In this post, I will detail the discovery of Envoy's dynamic rewriting location capabilities and the relationship to OCI registries.

****What is [Envoy](https://www.envoyproxy.io/)?****

> open source edge and service proxy, designed for cloud-native applications

****What is an [OCI container registry](https://opencontainers.org/)?****

> a standard, and specification, for the implementation of container registries

I've been playing around with and learning Envoy for a number of months now. One of the concepts I'm investigating is rewriting the request's host.
Envoy is a super powerful piece of software. It is flexible and highly dynamic.


## Journey {#journey}


### My expectations {#my-expectations}

The goal is to set up Envoy on a host to rewrite all requests dynamically back to a container registry hosted by a cloud-provider, such as GCP.


### Initial discoveries {#initial-discoveries}

One of the first things I investigated was the ability to get traffic from one site and serve it on another (proxying).
I searched in the docs and in their [most basic example](https://www.envoyproxy.io/docs/envoy/v1.17.1/start/quick-start/configuration-static) could see that, by using envoy's http filter in the filter\_chains, a static host could be rewritten.

Example:

```yaml
...
static_resources:
  listeners:
  - name: listener_0
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 10000
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: ingress_http
          access_log:
          - name: envoy.access_loggers.file
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog
              path: /dev/stdout
          http_filters:
          - name: envoy.filters.http.router
          route_config:
            name: local_route
            virtual_hosts:
            - name: local_service
              domains: ["*"]
              routes:
              - match:
                  prefix: "/"
                route:
                  host_rewrite_literal: www.envoyproxy.io
                  cluster: service_envoyproxy_io
...
```

This is a great start! This serves the site and its content under the host where Envoy is served.
However, the host in the rewrite is static and not dynamic. It seems at this point like doing the implementation this way is not viable.


### Learning about filter-chains {#learning-about-filter-chains}

Envoy has the lovely feature to set many kinds of middleware in the middle of a request.
This middleware can be used to add/change/remove things from the request.
Envoy is particularly good at HTTP related filtering. It also supports such features as dynamic forward proxy, JWT auth, health checks, and rate limiting.

The functionality is infinitely useful as filters can be such things as gRPC, PostgreSQL, Wasm, and even Lua.


### The implementation {#the-implementation}

Once I found the ability to write Lua as a filter, I found that it provided enough capability to perform the dynamic host rewrite.

```yaml
static_resources:
  listeners:
  - name: main
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 10000
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          stat_prefix: ingress_http
          codec_type: auto
          route_config:
            name: local_route
            virtual_hosts:
            - name: local_service
              domains:
              - "*"
              routes:
              - match:
                  prefix: "/"
                route:
                  cluster: web_service
          http_filters:
          - name: envoy.filters.http.lua
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua
              inline_code: |
                local reg1 = "k8s.gcr.io"
                local reg2 = "registry-1.docker.io"
                local reg2WithIP = "192.168.0.1"
                function envoy_on_request(request_handle)
                  local reg = reg1
                  remoteAddr = request_handle:headers():get("x-real-ip")
                  if remoteAddr == reg2WithIP then
                    request_handle:logInfo("remoteAddr: "..reg2WithIP)
                    reg = reg2
                  end
                  if request_handle:headers():get(":method") == "GET" then
                    request_handle:respond(
                      {
                        [":status"] = "302",
                        ["location"] = "https://"..reg..request_handle:headers():get(":path"),
                        ["Content-Type"] = "text/html; charset=utf-8",
                        [":authority"] = "web_service"
                      },
                      '<a href="'.."https://"..reg..request_handle:headers():get(":path")..'">'.."302".."</a>.\n")
                  end
                end
          - name: envoy.filters.http.router
            typed_config: {}

  clusters:
  - name: web_service
    connect_timeout: 0.25s
    type: LOGICAL_DNS
    lb_policy: round_robin
    load_assignment:
      cluster_name: web_service
      endpoints:
      - lb_endpoints:
        - endpoint:
            address:
              socket_address:
                address: ii.coop
                port_value: 443
```

With envoy running this config, the behaviour of the requests is

-   rewrite all traffic hitting the web service to _k8s.gcr.io_
-   except if the IP is _192.168.0.1_ then set the location to _registry-1.docker.io_

Since I'm using a [Pair](https://github.com/sharingio/pair) instance, it sets the local subnet to _192.168.0.0/24_ so when I try to `docker pull humacs-envoy-10000.$SHARINGIO_PAIR_BASE_DNS_NAME/library/postgres:12-alpine` it will go to _docker.io_.

On my local machine, pulling container images using `docker pull humacs-envoy-10000.$SHARINGIO_PAIR_BASE_DNS_NAME/e2e-test-images/agnhost:2.26` will instead use _k8s.gcr.io_.

To achieve this, I research how other http libraries handle redirects - namely [Golang's net/http.Redirect](https://golang.org/src/net/http/server.go?s=66471:66536#L2179).
The main things that Golang's _http.Redirect_ does is:

-   set the _content-type_ header to _text/html_
-   set the location to the destination
-   set the status code to 302
-   set the body to the same data in earlier steps, but in an _a_ tag.


## Final thoughts {#final-thoughts}

I'm learning that Envoy is highly flexible and seemly limitless in it's capabilities.

It's exciting to see Envoy being adopted in so many places - moreover to see the diverse usecases and implementations.

Big shout out to [Zach](https://ii.coop/author/zach-mandeville) for pairing on this with a few different aspects and attempts! (Zach is cool:tm:)
