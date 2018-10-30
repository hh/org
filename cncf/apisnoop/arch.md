
# Table of Contents

1.  [Summary](#orgfc021cf)
    1.  [Who are you? Why are you here?](#org6fda073)
2.  [Motivation](#orgb551cd2)
    1.  [Goals](#org0f51420)
    2.  [Non-Goals](#orge17b252)
        1.  [Define new prow jobs for entire community](#orgb86adc6)
3.  [Proposal](#orgca09db1)
    1.  [API interaction Identity (Who are you?)](#orgc5be040)
    2.  [API interaction Purpose (Why are you here?)](#org7898f1f)
    3.  [Self Identification and Purpose (What does introspection tell you?)](#org65408de)
    4.  [How do we communicate these larger concepts of identity and purpose?](#orgfd1224c)
    5.  [Tying it all together: (How do I turn this on?)](#orgfe2c9b9)
    6.  [Enable communication of 'Who are you?' and 'Why are you here?'](#org0d6e048)
        1.  [for any application using kubernetes API](#org9c6e4b1)
        2.  [via the official protocols and libraries and existing CI Infra](#org3aa566c)
        3.  [Document creation of prow jobs and resulting artifacts buckets for inclusion.](#orge6e38fc)
    7.  [User Stories](#org243bb31)
        1.  [SIG Component 'end-user' identification and usage patterns](#orgff5fa15)
        2.  [SIG informed test writing / conformance patterns](#org1429e86)
        3.  [Developer with a relational / community view](#org932b08e)
    8.  [Implementation Details/Notes/Constraints](#org1a740d0)
    9.  [Risks and Mitigations](#org7e16386)
4.  [Implementation History](#orge78f2d7)
5.  [Alternatives [optional]](#org9772320)
    1.  [Record the audit-id + whakapa and a file that gets uploaded to GCS](#org290f970)
6.  [Our own Context (scratch)](#org873b063)
    1.  [<code>[100%]</code> Questions for our discussion](#org0ca28d0)
        1.  [our architecture is made up of:](#orgc193711)
7.  [Design](#orgd6941aa)
8.  [Goals](#orgee5ffc5)
9.  [Conformance Jobs](#org0c5d5bf)
    1.  [Prow Job Definitions](#org9230120)
    2.  [Results Uploaded to GCS Buckets](#org3b9e344)
10. [Conformance Results](#org7f528d4)
11. [Existing Conformance Dashboards (test-grid)](#org80daa7c)
    1.  [Dashboard Definitions](#org68bc530)
        1.  [dashboard<sub>groups</sub>: conformance](#orga82e213)
        2.  [dashboards: conformance-gce](#org3d45efb)
        3.  [test<sub>groups</sub>: ci-kubernetes-gce-conformance-\*](#orgfedadfe)
12. [K8s e2e Conformance Jobs](#orgf3fa954)
    1.  [Where does kubetest download like ci-latest](#orgca69163)
    2.  [kubekins](#orge3f9e65)



<a id="orgfc021cf"></a>

# Summary

The cultural concepts of mihi and whakapapa are the foundation of this KEP. The
application of these concepts within our community ecosystem deserves a shout
out to the Māori of Aoteroa, Land of the Long White Cloud.

New Zealand hasn’t been populated for very long compared to the rest of the
world. The first people (Māori) arrived on waka (canoes) around the 15th
century. For Maori people today, the name of the specific waka that their
ancestors arrived on, combined with their own genealogical journey defines who
they are (in a very meaningful specific way). When mihi (formal introductions)
are made, they include their own parental lineage back to the name of the waka
their ancestors arrived in. The knowledge and communication of this history
often leads to newly introduced people becoming cognitive of familial historic
connections between them. This concrete and relational definition of identity is
called their whakapapa.

Te Reo/Māori: He mea nui ki a tātau ō tātau whakapapa (HP 1991:1). English: Our
genealogies are important to us.


<a id="org6fda073"></a>

## Who are you? Why are you here?

Let’s enable any application, using our official Kubernetes libraries and existing CI/Testing infrastructure, to provide data to answer these questions. We need to make room for recording the context for each interaction with the APIServer.

The aggregated clusterwide correlation of identity and user journey with each API request/response would provide the raw metadata necessary to explore the interwoven, but presently unseen, patterns of our user journeys within the Kubernetes community.


<a id="orgb551cd2"></a>

# Motivation

We need an atlas of the invisible and undefined tribal patterns within the ecosystem of our community.

This map would help chart our course of development, testing, and conformance based on actual Kubernetes usage patterns.


<a id="org0f51420"></a>

## Goals

Provide a set of community insights based on publically available data, easily allowing others to create new data or insight.

1.  Cross Community - Source code / line level next insights

    As a specific line of code (LoC) hits the API server, we will record the LoC
    (callstack) that brought it here to articulate that LoC's whakapapa. Combined
    with other API requests, we can infer which other LoC utilize and depend on it,
    as they hit each endpoint.
    
    Ideally this is across all repos and organizations, and for every binary in a
    cluster, eventually linking LoC (and the OWNERS that curate them) througout our
    community in a relational way.

2.  Kubernetes Endpoint coverage by e2e

    Go beyond simple endpoint % hit metrics, providing relational data between
    individual tests (and sigs that own them), the endpoints they hit, and the LoC
    involved (both server and client side).

3.  Common Endpoint journey patterns / suggested test

    Analyzing audit / whakapapa logs from multiple applications, suggesting skeleton
    tests based on these patterns.


<a id="orge17b252"></a>

## Non-Goals


<a id="orgb86adc6"></a>

### Define new prow jobs for entire community

I'm hoping to help others write these.


<a id="orgca09db1"></a>

# Proposal

To aggregate identity and purpose <span class="underline">**at the time of API interactions**</span>, we need:

1.  <span class="underline">**The who and why**</span> : Define ‘identity’ and ‘purpose’
2.  <span class="underline">**App introspection**</span> : generated at time of interaction:
3.  <span class="underline">**For all apps and the cluster itself**</span> : allowing 'global' src, function, and API call mapping


<a id="orgc5be040"></a>

## API interaction Identity (Who are you?)

Current API interaction client-‘identity’ is static and usually set in client-go
via user-agent to something like:

    e2e.test/v1.12.0 (linux/amd64) kubernetes/b143093
    kube-apiserver/v1.12.0 (linux/amd64) kubernetes/b143093
    kube-controller-manager/v1.12.0 (linux/amd64) kubernetes/b143093
    kubectl/v1.12.0 (linux/amd64) kubernetes/b143093
    kubelet/v1.12.0 (linux/amd64) kubernetes/b143093
    kube-scheduler/v1.12.0 (linux/amd64) kubernetes/b143093

Ideally our base ‘identity’ should at least miminally tie an application back to particular src commit,
though some programs (like kernel info via uname) also show compile time info
like timestamp or build user/machine:

    $ uname -a
    Darwin ii.local 10.3.0 Darwin Kernel Version 10.3.0: Fri Oct 26 1:21:00 NZT 1985; root:xnu-1504.3.12~1/RELEASE_I386 i386

Possibly something like:

    kubelet/v1.12.0 (linux/amd64) k8s.io/kubelet b143093 built by test-infra@buildbot-10 02/03/85 23:44


<a id="org7898f1f"></a>

## API interaction Purpose (Why are you here?)

Going beyond a particular build of a source tree into a binary, we must define a
simple to implement, but contextually significant, answer to the question:

**Why are you here?**

Its difficult to glean the purpose of an application interaction by external
inspection without making room for this question.

At the moment of making the API call, the application has access its own stack
and history of source code location/lines and functions that brought it to make
a request of an external API. Disabled by default, it could be enabled by
setting a variable such as \`KUBE<sub>CLIENT</sub><sub>SUBMIT</sub><sub>PURPOSE</sub>\`.

Allowing the application to supply this <span class="underline">‘mental snapshot of purpose’</span> could be
as simple as providing space in our protocol for including source and method
callstacks.


<a id="org65408de"></a>

## Self Identification and Purpose (What does introspection tell you?)

Introspection is available in many of the languages that have official
Kubernetes client libraries.

Go, Python, and Java all provide the ability to inspect the runtime and stack
programmatically, and include source paths and line numbers.

It may help to provide an example introspection:

    "introspection": {
      "self-identity": "kube-apiserver/v1.12.0 (linux/amd64) b143093 compiled by CNCF Fri Feb 26 11:58:09 PST 2010",
      "current-purpose": [
        "k8s.io/client-go/rest.(*Request).Do()",
        "k8s.io/client-go/kubernetes/typed/admissionregistration/v1alpha1.(*initializerConfigurations).List()",
        "k8s.io/apiserver/pkg/admission/configuration.NewInitializerConfigurationManager.func1()",
        "k8s.io/apiserver/pkg/admission/configuration.(*poller).sync()",
        "k8s.io/apiserver/pkg/admission/configuration.sync)-fm()",
        "k8s.io/apimachinery/pkg/util/wait.JitterUntil.func1()",
        "k8s.io/apimachinery/pkg/util/wait.JitterUntil()",
        "k8s.io/apimachinery/pkg/util/wait.Until()",
        "runtime.goexit()"
      ],
      "current-reasoning": [
        "k8s.io/client-go/rest/request.go:807",
        "k8s.io/client-go/kubernetes/typed/admissionregistration/v1alpha1/initializerconfiguration.go:79",
        "k8s.io/apiserver/pkg/admission/configuration/initializer_manager.go:42",
        "k8s.io/apiserver/pkg/admission/configuration/configuration_manager.go:155",
        "k8s.io/apiserver/pkg/admission/configuration/configuration_manager.go:151",
        "k8s.io/apimachinery/pkg/util/wait/wait.go:133",
        "k8s.io/apimachinery/pkg/util/wait/wait.go:134",
        "k8s.io/apimachinery/pkg/util/wait/wait.go:88",
        "runtime/asm_amd64.s:2361"
      ],
    }


<a id="orgfd1224c"></a>

## How do we communicate these larger concepts of identity and purpose?

Currently the freeform concept of identity is limited what can fit within the
user-agent field.

Support for recording the [user-agent field in our
audit-events](<https://github.com/kubernetes/kubernetes/pull/64812>) was recently
added, but our initial explorations depend on that field allowing up to 4k.

For e2e tests, we've added support for sending the test string. However, for a
community wide approach, we'll need to augment client-go to either send the
whakapapa via the request in a optional whakapa field (which would simplify log
collection long term).


<a id="orgfe2c9b9"></a>

## Tying it all together: (How do I turn this on?)

If all applications are compiled against a client-go (or other supported library)
and support the env var \`KUBE<sub>CLIENT</sub><sub>SUBMIT</sub><sub>PURPOSE</sub>\`,
then deploying kubernetes itself with it set should
enable all kubernetes components to begin transmitting identity and purpose.

Setting this variable on all pods could be accomplished with
an admission or initialization controller allowing every binary
run on and within the cluster to do the same.

Currently this data is transmitted via user-agent,
so configuring an audit-logging webhook,
dynamic or otherwise, would allow centralized aggregation.


<a id="org0d6e048"></a>

## Enable communication of 'Who are you?' and 'Why are you here?'


<a id="org9c6e4b1"></a>

### for any application using kubernetes API

Ideally we would like to provide instrumentation to any application talking to kubernetes, not just our e2e test suite.


<a id="org3aa566c"></a>

### via the official protocols and libraries and existing CI Infra

Audit-logging provides a centralized logging mechanism, but we need to make room somewhere for the `whakapapa` style metadata.

This data needs to be available via the job output / gcsweb buckets.

Some options:

1.  Submit whakapapa via API calls params thet show up in the audit-logs

2.  Submit whakapapa hash of some sort via User-Agent (1k limit) => audit-logs


<a id="orge6e38fc"></a>

### Document creation of prow jobs and resulting artifacts buckets for inclusion.

Jobs need to be configured to generate at least audit logs, in a predefined location, and possible whakapapa audit/hash logs.


<a id="org243bb31"></a>

## User Stories


<a id="orgff5fa15"></a>

### SIG Component 'end-user' identification and usage patterns

As a SIG member, who uses the components we curate and what are they doing with them?


<a id="org1429e86"></a>

### SIG informed test writing / conformance patterns

As a SIG member choosing test to write/upgrade to conformance tests,
what patterns and endpoints occur within our community vs what we currently test for.


<a id="org932b08e"></a>

### Developer with a relational / community view

As a developer, I'd like to know the existing tests and applications
that have similar patterns or hit the endpoints I'm interested in.


<a id="org1a740d0"></a>

## Implementation Details/Notes/Constraints


<a id="org7e16386"></a>

## Risks and Mitigations


<a id="orge78f2d7"></a>

# Implementation History

-   06/27/2018: initial design via google doc
-   07/11/2018: submission of KEP
-   07/??/2018: sponsorship by sig-????


<a id="org9772320"></a>

# Alternatives [optional]


<a id="org290f970"></a>

## Record the audit-id + whakapa and a file that gets uploaded to GCS

If we instrument applications by having them write audit-id + whakapa to lags,
we would need to ensure they end of in the GCS bucket, and it would now allow
dynamic audit configuration as a method.


<a id="org873b063"></a>

# Our own Context (scratch)

simple summary of purpose: 'With data that provides the context of usage of kubernetes api (who is using it, where are they coming from, why are they doing this?), we can begin to visualize patterns of usage for kubernetes that will help us chart our course of development, testing, and conformance that's based on actual Kubernetes usage.   Through this, the k8s community (and conformance group) can  prioritize what endpoints are being tested, or which ones need more attention.  It will also help the community better understand who among them are working on which things, and why."

This summary has some inherent stages: 

-   data being provided to us
-   that data having usage context
-   us having a way to share this to the k8s community.
-   There is a feedback loop
-   Our sharing being presented in a meaningful and inviting way for the community.

it's not about just making moreo tests, what are we testing on?  We can make tests that pass, but they may not be 'meaningful tests'.  If conformance is k8s figuring itself out, what things conform to our definition of ourselves, then meaning comes from who *we* are, what *we* are doing that k8s is conforming to.


<a id="org0ca28d0"></a>

## <code>[100%]</code> Questions for our discussion

-   [X] Is this summary correct for apisnoop?
-   [X] Are the stages accurate?
-   [X] If this is true, then what stage are we in right now?
    -   Right now we are only running this for a single user, the e2e test suite.  And for this beginning version, that is enough.  And so we can say that we are having data provided to us, and so we are past stage 1.
    -   Even at this point, new questions emerged when we shared findings to sig-testing:  Can we filter based on test name?  IF we drop down into a sig, what does it mean to see a sig within a test.  It's based on labels.  Can we filter by labels then?
    -   This sharing of our initial interface was step 3, but the sharing engendered not only  new questions about how we are grabbing data and its context, but also questions for **how we are allowing for people to explore the data and ask questions of this data.**
-   [X] Do we have step 1 and 2 accomplished?  Do we need to have them accomplished before we try to share step 3?
    -   These may be different steps, but they are not linear.  Work done on step 3 enables more questions to be asked about the data and what context it has.  In other words, step 3 feeds back into step 1 and 2 and the way it feeds back generates new demands for step 3.  It is a cycle.  A stronger base for 3 will create a stronger base for 1 and 2 which in turns will create an even STRONGER base for 3.
-   [X] If not, what have we done and what are we doing to accomplish this?
    -   We are refactoring the web interface to tighten our iteration loop, and be able to respond more quickly with the suggestions of the community for how they want to explore the data.
    -   We are strategizing for how the data comes in, and how we can combine existing information into a single source to draw from, a source that is now more meaningful for the context it brings in.  In other words, we can pull audit logs fro test grid, and these audit logs will name the SIG or test<sub>group</sub> this job is a part of&#x2026;but it won't give further context about either.  This further context can be found in yaml files distributed across our git repos, but it can take some sleuthing and heavy brain work to remember where to find them, and how they all interrelate.  We are building a backend that does that sleuthing and combining for us&#x2013;so that we can start to do the higher-level patterns instead of just searching out and keeping track of the raw data.
-   [X] How many of these stages are within the domain of apisnoop work, and how much is assumed to be handled by someone else?
    -   Auditing has to be configured and it's a pain in the butt right now.
    -   There's a new feature called 'dyanmic audit configuration' that made this easier.  We didn't ask them to do this, but it came within 4 hours of our KEP.  And so the vision we are bringing forward new features of kubernetes through the vision provided in our long-term strategies.  In other words, we are helping define what kubernetes  is&#x2013;and so the 'soft work' is directly contributing to conformance.
    -   So this dynamic auditing is going to help us bring in the data that will inform our web interface.
    -   In other words, a dropdown filter asumes there is data to filter upon and context in which to build the dropdown options.  It also assumes that we can grab this data and context quickly.  We are doing work to make both of these assumptions trueo


<a id="orgc193711"></a>

### our architecture is made up of:

-   the existing work of test-infra.  
    -   We lean heavily on prow
    -   job results
    -   the test grid config (mostly to find which buckets to pull from).
-   we are creating a workflow pipeline of prow => gcsbucket to quickly iterate over data creation
-   we are creating an extensible data-processing and visualization platform
    -   made up of modular components
    -   Easier to respond to community requests and build out new visualizations and features
    -   data processing has a clear api to draw from to pull out consistent data for our visualizations.

a stable and extensible.

-   [ ] If there is no known handler, than do these tasks become a part of our work and architecture?

The feedback loop is an important part of our purpose, to share this with conformance and sig-testing and see what sort of patterns are meaningful to them.  With the earliest versions, we already had useful feedback for what it is they'd like to do.  They want to interact with real data, and they want to be able to filter the data on some dynamic points and take actions from these.  The actions would be 'suggest tests' and 'suggest areas that are critically untested, and so endpoints within that area to be tested', 'suggest existing tests that do meaningful things that promote conformance', 'suggest meaningful ways the community is using the api and emerging patterns.'

This made us realize that we'd need to tighten our own iteration loop for the web interface, to better respond to the feedback around filters and actions.  The first version was not easily extensible, and required extensive manual work to update the page and add in new features.  And so we are working to build a more exensible backend for our interface, to be able to provide the actionable filters and insights.  This is already known as a need, but we are saying this is also a primary strategy for how we work.  The refactoring to create a tighter iteration loop is crucial for how we bring in data, and how we add context to that data.  \* Objective 

In order to provide conformance metrics and actionable data to the CNCF
Conformance WG, we want to continuously utilize the output from our conformance
related prow-jobs.

Starting with the jobs displayed via test-grid/conformance-gce, we want to
create analysis and visualization tools to understand:

-   what tests hit which endpoints
-   what percentage of endpoints are hit (over time)
-   how our community using the k8s api
-   ???

Afterwards, we will combine Kubernetes application tests from across the CNCF
and beyond, to analyze real world usage patterns. This data will be used to see
patterns of usage and suggest new tests.


<a id="orgd6941aa"></a>

# Design

Using various methods to create and capture more context around API communications,
we will ensure that the artifacts pushed by prow jobs contain the information necessary
to drive deeper analysis.

Conformance related jobs (and their artifacts) will be pulled for analysis and
visualization. Anyone should be able to fork and bring up their own analysis and
contribute.


<a id="orgee5ffc5"></a>

# Goals

-   Build a simple api to provide access, analysis of prow job output/data
-   Create a process to quickly iterate on development of new jobs (destined for prow.k8s.io)
-   Add features to combine and visualize output across multiple jobs and buckets
-   Generate actionable conformance coverage reports / test suggestions


<a id="org0c5d5bf"></a>

# Conformance Jobs


<a id="org9230120"></a>

## Prow Job Definitions

Prow jobs are defined in subfolders of [k8s/test-infra/config/jobs](https://github.com/kubernetes/test-infra/tree/master/config/jobs) though most of
the conformance-gce jobs seem to be part of [sig-gcp](https://github.com/kubernetes/community/tree/master/sig-gcp) as they are under
[config/jobs/kubernetes/sig-gcp](https://github.com/kubernetes/test-infra/blob/master/config/jobs/kubernetes/sig-gcp/) in [gce-conformance.yaml](https://github.com/kubernetes/test-infra/blob/master/config/jobs/kubernetes/sig-gcp/gce-conformance.yaml)

So far the conforance-gce jobs seem to be configured to run every 6 hours and
take about 2 hours to run.


<a id="org3b9e344"></a>

## Results Uploaded to [GCS Buckets](https://cloud.google.com/storage/docs/json_api/v1/buckets)

I'm unsure where it's configured, but `kubernetes-jenkins/logs` is prepended to
`<job name>` for all prow.k8s.io jobs.

[gcsupload](https://github.com/kubernetes/test-infra/blob/master/prow/cmd/gcsupload/README.md) or [jenkins/bootstrap.py#upload<sub>artifacts</sub>()](https://github.com/kubernetes/test-infra/blob/master/jenkins/bootstrap.py#L397) is likely responsible for this work.


<a id="org7f528d4"></a>

# Conformance Results


<a id="org80daa7c"></a>

# Existing Conformance Dashboards (test-grid)

We focused on the [k8s-testgrid/conformance-gce](https://k8s-testgrid.appspot.com/conformance-gce) and it's tabs.

-   [GCE, master (dev)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520master%2520(dev))
-   [GCE, v1.12 (dev)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.12%2520(dev))
-   [GCE, v1.11 (dev)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.11%2520(dev))
-   [GCE, v1.10 (dev)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.10%2520(dev))
-   [GCE, v1.9  (dev)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.9%2520(dev))

-   [GCE, v1.12 (release)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.12%2520(release))
-   [GCE, v1.11 (release)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.11%2520(release))
-   [GCE, v1.10 (release)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.10%2520(release))
-   [GCE, v1.9  (release)](https://k8s-testgrid.appspot.com/conformance-gce#GCE,%2520v1.9%2520(release))


<a id="org68bc530"></a>

## Dashboard Definitions

Dashboards are configured via [k8s/test-infra/testgrid/config.yaml#Prow hosted
conformance tests](https://github.com/kubernetes/test-infra/blob/master/testgrid/config.yaml#L3014) and are configured in a bit of a higherarchy.


<a id="orga82e213"></a>

### dashboard<sub>groups</sub>: [conformance](https://github.com/kubernetes/test-infra/blob/f3b96c7fcf9ef6b0411dc126e42a1618c1524187/testgrid/config.yaml#L7430)

    - name: conformance
      dashboard_names:
      - conformance-all
      - conformance-gce


<a id="org3d45efb"></a>

### dashboards: [conformance-gce](https://github.com/kubernetes/test-infra/blob/f3b96c7fcf9ef6b0411dc126e42a1618c1524187/testgrid/config.yaml#L3373)

    - name: conformance-gce
      dashboard_tab:
      - name: GCE, master (dev)
        description: Runs conformance tests using kubetest against latest kubernetes master CI build on GCE
        test_group_name: ci-kubernetes-gce-conformance
      - name: GCE, v1.12 (release)
        description: Runs conformance tests using kubetest against kubernetes release 1.12 stable tag on GCE
        test_group_name: ci-kubernetes-gce-conformance-stable-1-12
        # TODO(bentheelder): there's probably a more appropriate alias to alert this to
        alert_options:
          alert_mail_to_addresses: gke-kubernetes-engprod+alerts@google.com
      - name: GCE, v1.12 (dev)
        description: Runs conformance tests using kubetest against kubernetes release 1.12 branch on GCE
        test_group_name: ci-kubernetes-gce-conformance-latest-1-12


<a id="orgfedadfe"></a>

### test<sub>groups</sub>: [ci-kubernetes-gce-conformance-\*](https://github.com/kubernetes/test-infra/blob/f3b96c7fcf9ef6b0411dc126e42a1618c1524187/testgrid/config.yaml#L3014)

    # Prow hosted conformance tests
    - name: ci-kubernetes-gce-conformance
      gcs_prefix: kubernetes-jenkins/logs/ci-kubernetes-gce-conformance
      num_columns_recent: 3
      alert_stale_results_hours: 24
      num_failures_to_alert: 1
    - name: ci-kubernetes-gce-conformance-stable-1-12
      gcs_prefix: kubernetes-jenkins/logs/ci-kubernetes-gce-conformance-stable-1-12
      num_columns_recent: 3
      alert_stale_results_hours: 24
      num_failures_to_alert: 1
    - name: ci-kubernetes-gce-conformance-latest-1-12
      gcs_prefix: kubernetes-jenkins/logs/ci-kubernetes-gce-conformance-latest-1-12

Testgrid provides a webui around job results stored in gubernator / gcsweb.

We don't directly interact with testgrid, but we use the [config](https://github.com/kubernetes/test-infra/blob/master/testgrid/config.yaml#L3014) to find the
correct gcs<sub>prefixes</sub>. 

Testgrid provides a webui around job results stored in gubernator / gcsweb.

We don't directly interact with testgrid, but we use the [config](https://github.com/kubernetes/test-infra/blob/master/testgrid/config.yaml#L3014) to find the
correct gcs<sub>prefixes</sub>. 


<a id="orgf3fa954"></a>

# K8s e2e Conformance Jobs

Our focus in to take 

They are configured via
[k8s/test-infra/testgrid/config.yaml#Prow hosted conformance tests](https://github.com/kubernetes/test-infra/blob/master/testgrid/config.yaml#3014) and all have  

testgrid provides a webui around job results stored in gubernator / gcsweb.

We don't directly interact with testgrid, but we use the [config](https://github.com/kubernetes/test-infra/blob/master/testgrid/config.yaml#L3014) to find the
correct gcs<sub>prefixes</sub>. Currently we filter on testgroup 

We iterate over

dashboards[conformance-gce].dashboard<sub>tab</sub>[x].test<sub>group</sub><sub>name</sub>
test<sub>groups</sub>[Z].gcs<sub>prefix</sub>

Then we prepend gcsweb.k8s.io/gcs

Each test<sub>group</sub> pulls from a specific gcs<sub>prefix</sub>.

Jobs are defined at [k8s/test-infra/jobs](https://github.com/kubernetes/test-infra/tree/master/config/jobs) though most of the conformance dashboard are at
[config/jobs/kubernetes/sig-gcp/gce-conformance.yaml](https://github.com/kubernetes/test-infra/blob/master/config/jobs/kubernetes/sig-gcp/gce-conformance.yaml)

 most of our conformance jobs
have a periodic run of about 6 hours. It takes usually takes 2 hours for them to
run.


<a id="orgca69163"></a>

## Where does kubetest download like ci-latest


<a id="orge3f9e65"></a>

## kubekins

Everything runs under kubekins

<https://github.com/kubernetes/test-infra/tree/master/images/kubekins-e2e>
<https://github.com/kubernetes/test-infra/tree/master/images/kubekins-test>

gcr.io/k8s-testimages/kubekins-e2e-prow

[gcr/images/k8s-testimages/GLOBAL/kubekins-e2e-prow](https://console.cloud.google.com/gcr/images/k8s-testimages/GLOBAL/kubekins-e2e-prow?pli=1)

