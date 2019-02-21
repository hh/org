  - [Debug Init containers](#sec-1)

```shell
kubectl get pod \
  -l app=sidekiq \
  --namespace=gitlab \
  -o json \
| jq -M .
```

# Debug Init containers<a id="sec-1"></a>

<https://kubernetes.io/docs/tasks/debug-application-cluster/debug-init-containers/>

```shell
kubectl describe `kubectl get pod -l app=sidekiq --namespace=gitlab -o name` --namespace=gitlab
```

    Name:               gitlab-sidekiq-all-in-1-64c87c795b-wrx22
    Namespace:          gitlab
    Priority:           0
    PriorityClassName:  <none>
    Node:               ci.ii.coop/139.178.88.146
    Start Time:         Thu, 21 Feb 2019 15:38:24 +1300
    Labels:             app=sidekiq
                        pod-template-hash=64c87c795b
                        release=gitlab
    Annotations:        checksum/configmap: d60eb12282fc9d74a04175ae12359ebd94a522ade74cef0053dfc601116849d3
                        checksum/configmap-pod: 31b99a4a71c3ab443a22b879ad69dfa437edf33f8292b0ae3835c02cbf1047ea
                        cluster-autoscaler.kubernetes.io/safe-to-evict: true
                        prometheus.io/port: 3807
                        prometheus.io/scrape: true
    Status:             Pending
    IP:                 10.244.0.209
    Controlled By:      ReplicaSet/gitlab-sidekiq-all-in-1-64c87c795b
    Init Containers:
      certificates:
        Container ID:   docker://4a74cf95f171347de42433cb2dab7527995aa1e328172bcea405f1e6ec75ff5b
        Image:          registry.gitlab.com/gitlab-org/build/cng/alpine-certificates:20171114-r3
        Image ID:       docker-pullable://registry.gitlab.com/gitlab-org/build/cng/alpine-certificates@sha256:bf07c7b34ef86f22370e5a3e0e2a0f7e51a24e0ad6c27108cae59c64e244e2c3
        Port:           <none>
        Host Port:      <none>
        State:          Terminated
          Reason:       Completed
          Exit Code:    0
          Started:      Thu, 21 Feb 2019 15:38:28 +1300
          Finished:     Thu, 21 Feb 2019 15:38:28 +1300
        Ready:          True
        Restart Count:  0
        Requests:
          cpu:        50m
        Environment:  <none>
        Mounts:
          /etc/ssl/certs from etc-ssl-certs (rw)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-tfwcn (ro)
      configure:
        Container ID:  docker://d79546e8f95b925f86a81b288fc8541af440a39af5cb8a79864de38121198827
        Image:         busybox:latest
        Image ID:      docker-pullable://busybox@sha256:061ca9704a714ee3e8b80523ec720c64f6209ad3f97c0ff7cb9ec7d19f15149f
        Port:          <none>
        Host Port:     <none>
        Command:
          sh
          /config/configure
        State:          Terminated
          Reason:       Completed
          Exit Code:    0
          Started:      Thu, 21 Feb 2019 15:38:30 +1300
          Finished:     Thu, 21 Feb 2019 15:38:30 +1300
        Ready:          True
        Restart Count:  0
        Requests:
          cpu:        50m
        Environment:  <none>
        Mounts:
          /config from sidekiq-config (ro)
          /init-secrets from init-sidekiq-secrets (ro)
          /sidekiq-secrets from sidekiq-secrets (rw)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-tfwcn (ro)
      dependencies:
        Container ID:  docker://bb2d3af29db91640865de5572a7cb92eb5215ba6736f384d41aa708508fafc0e
        Image:         registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v11.7.5
        Image ID:      docker-pullable://registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce@sha256:df2c7329c885f002a1e941e08838736e6714829d80460eb59c05f9b4066e6724
        Port:          <none>
        Host Port:     <none>
        Args:
          /scripts/wait-for-deps
        State:          Waiting
          Reason:       CrashLoopBackOff
        Last State:     Terminated
          Reason:       Error
          Exit Code:    1
          Started:      Thu, 21 Feb 2019 16:15:11 +1300
          Finished:     Thu, 21 Feb 2019 16:15:11 +1300
        Ready:          False
        Restart Count:  12
        Requests:
          cpu:  50m
        Environment:
          GITALY_FEATURE_DEFAULT_ON:  1
          CONFIG_TEMPLATE_DIRECTORY:  /var/opt/gitlab/templates
          CONFIG_DIRECTORY:           /srv/gitlab/config
          SIDEKIQ_CONCURRENCY:        25
          SIDEKIQ_TIMEOUT:            5
        Mounts:
          /etc/gitlab from sidekiq-secrets (ro)
          /var/opt/gitlab/templates from sidekiq-config (ro)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-tfwcn (ro)
    Containers:
      sidekiq:
        Container ID:   
        Image:          registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v11.7.5
        Image ID:       
        Port:           3807/TCP
        Host Port:      0/TCP
        State:          Waiting
          Reason:       PodInitializing
        Ready:          False
        Restart Count:  0
        Requests:
          cpu:      50m
          memory:   650M
        Liveness:   exec [pgrep -f sidekiq] delay=0s timeout=1s period=10s #success=1 #failure=3
        Readiness:  exec [head -c1 /dev/random] delay=0s timeout=1s period=10s #success=1 #failure=3
        Environment:
          prometheus_multiproc_dir:   /metrics
          GITALY_FEATURE_DEFAULT_ON:  1
          CONFIG_TEMPLATE_DIRECTORY:  /var/opt/gitlab/templates
          CONFIG_DIRECTORY:           /srv/gitlab/config
          SIDEKIQ_CONCURRENCY:        25
          SIDEKIQ_TIMEOUT:            5
        Mounts:
          /etc/gitlab from sidekiq-secrets (ro)
          /etc/ssl/certs/ from etc-ssl-certs (ro)
          /metrics from sidekiq-metrics (rw)
          /srv/gitlab/INSTALLATION_TYPE from sidekiq-config (rw)
          /srv/gitlab/config/initializers/smtp_settings.rb from sidekiq-config (rw)
          /srv/gitlab/config/secrets.yml from sidekiq-secrets (rw)
          /var/opt/gitlab/templates from sidekiq-config (ro)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-tfwcn (ro)
    Conditions:
      Type              Status
      Initialized       False 
      Ready             False 
      ContainersReady   False 
      PodScheduled      True 
    Volumes:
      sidekiq-metrics:
        Type:    EmptyDir (a temporary directory that shares a pod's lifetime)
        Medium:  Memory
      sidekiq-config:
        Type:               Projected (a volume that contains injected data from multiple sources)
        ConfigMapName:      gitlab-sidekiq
        ConfigMapOptional:  <nil>
        ConfigMapName:      gitlab-sidekiq-all-in-1
        ConfigMapOptional:  <nil>
      init-sidekiq-secrets:
        Type:                Projected (a volume that contains injected data from multiple sources)
        SecretName:          gitlab-rails-secret
        SecretOptionalName:  <nil>
        SecretName:          gitlab-gitaly-secret
        SecretOptionalName:  <nil>
        SecretName:          gitlab-redis-secret
        SecretOptionalName:  <nil>
        SecretName:          gitlab-postgresql-password
        SecretOptionalName:  <nil>
        SecretName:          gitlab-registry-secret
        SecretOptionalName:  <nil>
        SecretName:          gitlab-minio-secret
        SecretOptionalName:  <nil>
      sidekiq-secrets:
        Type:    EmptyDir (a temporary directory that shares a pod's lifetime)
        Medium:  Memory
      etc-ssl-certs:
        Type:    EmptyDir (a temporary directory that shares a pod's lifetime)
        Medium:  Memory
      default-token-tfwcn:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-tfwcn
        Optional:    false
    QoS Class:       Burstable
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type     Reason       Age                 From                 Message
      ----     ------       ----                ----                 -------
      Normal   Scheduled    37m                 default-scheduler    Successfully assigned gitlab/gitlab-sidekiq-all-in-1-64c87c795b-wrx22 to ci.ii.coop
      Warning  FailedMount  37m                 kubelet, ci.ii.coop  MountVolume.SetUp failed for volume "sidekiq-config" : couldn't propagate object cache: timed out waiting for the condition
      Normal   Pulled       37m                 kubelet, ci.ii.coop  Container image "registry.gitlab.com/gitlab-org/build/cng/alpine-certificates:20171114-r3" already present on machine
      Normal   Created      37m                 kubelet, ci.ii.coop  Created container
      Normal   Started      37m                 kubelet, ci.ii.coop  Started container
      Normal   Pulling      37m                 kubelet, ci.ii.coop  pulling image "busybox:latest"
      Normal   Created      37m                 kubelet, ci.ii.coop  Created container
      Normal   Pulled       37m                 kubelet, ci.ii.coop  Successfully pulled image "busybox:latest"
      Normal   Started      37m                 kubelet, ci.ii.coop  Started container
      Normal   Pulled       36m (x4 over 37m)   kubelet, ci.ii.coop  Container image "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v11.7.5" already present on machine
      Normal   Created      36m (x4 over 37m)   kubelet, ci.ii.coop  Created container
      Normal   Started      36m (x4 over 37m)   kubelet, ci.ii.coop  Started container
      Warning  BackOff      2m (x163 over 37m)  kubelet, ci.ii.coop  Back-off restarting failed container

```shell
(
  kubectl get pod \
    -l app=sidekiq \
    --namespace=gitlab \
    -o json \
  | jq -M '.items[0].status.initContainerStatuses[] | select(.ready==false)'
) 2>&1
echo // errors should appear above this
#
```

```json
{
  "containerID": "docker://2ef97902897033b1d7efcfe955c52f6782db32851ba710db7c9e265a917f48c3",
  "image": "registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v11.7.5",
  "imageID": "docker-pullable://registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce@sha256:df2c7329c885f002a1e941e08838736e6714829d80460eb59c05f9b4066e6724",
  "lastState": {
    "terminated": {
      "containerID": "docker://2ef97902897033b1d7efcfe955c52f6782db32851ba710db7c9e265a917f48c3",
      "exitCode": 1,
      "finishedAt": "2019-02-21T03:10:05Z",
      "reason": "Error",
      "startedAt": "2019-02-21T03:10:05Z"
    }
  },
  "name": "dependencies",
  "ready": false,
  "restartCount": 11,
  "state": {
    "waiting": {
      "message": "Back-off 5m0s restarting failed container=dependencies pod=gitlab-sidekiq-all-in-1-64c87c795b-wrx22_gitlab(c2d93935-3581-11e9-bfc2-98039b302386)",
      "reason": "CrashLoopBackOff"
    }
  }
}
// errors should appear above this
```

```shell
(
  kubectl get pod \
    -l app=sidekiq \
    --namespace=gitlab \
    -o json \
  | jq -M '.items[0].status.conditions'
) 2>&1
echo // errors should appear above this
#[] | select(.type=="Ready")'
```

```json
[
  {
    "lastProbeTime": null,
    "lastTransitionTime": "2019-02-21T02:38:24Z",
    "message": "containers with incomplete status: [dependencies]",
    "reason": "ContainersNotInitialized",
    "status": "False",
    "type": "Initialized"
  },
  {
    "lastProbeTime": null,
    "lastTransitionTime": "2019-02-21T02:38:24Z",
    "message": "containers with unready status: [sidekiq]",
    "reason": "ContainersNotReady",
    "status": "False",
    "type": "Ready"
  },
  {
    "lastProbeTime": null,
    "lastTransitionTime": "2019-02-21T02:38:24Z",
    "message": "containers with unready status: [sidekiq]",
    "reason": "ContainersNotReady",
    "status": "False",
    "type": "ContainersReady"
  },
  {
    "lastProbeTime": null,
    "lastTransitionTime": "2019-02-21T02:38:24Z",
    "status": "True",
    "type": "PodScheduled"
  }
]
```

```shell
(
  kubectl logs \
      $(kubectl get pod \
        -l app=sidekiq \
        --namespace=gitlab \
        -o name )\
   --namespace=gitlab \
   -c certificates
) 2>&1
```

    rm: can't remove '/etc/ssl/certs/*': No such file or directory
    WARNING: ca-certificates.crt does not contain exactly one certificate or CRL: skipping

```shell
(
  kubectl logs \
      $(kubectl get pod \
        -l app=sidekiq \
        --namespace=gitlab \
        -o name )\
   --namespace=gitlab \
   -c configure
) 2>&1
```

    '/init-secrets/redis/./password' -> '/sidekiq-secrets/redis/./password'
    '/init-secrets/redis/.' -> '/sidekiq-secrets/redis/.'
    '/init-secrets/gitaly/./gitaly_token' -> '/sidekiq-secrets/gitaly/./gitaly_token'
    '/init-secrets/gitaly/.' -> '/sidekiq-secrets/gitaly/.'
    '/init-secrets/registry/./gitlab-registry.key' -> '/sidekiq-secrets/registry/./gitlab-registry.key'
    '/init-secrets/registry/.' -> '/sidekiq-secrets/registry/.'
    '/init-secrets/postgres/./psql-password' -> '/sidekiq-secrets/postgres/./psql-password'
    '/init-secrets/postgres/.' -> '/sidekiq-secrets/postgres/.'
    '/init-secrets/rails-secrets/./secrets.yml' -> '/sidekiq-secrets/rails-secrets/./secrets.yml'
    '/init-secrets/rails-secrets/.' -> '/sidekiq-secrets/rails-secrets/.'
    '/init-secrets/minio/./secretkey' -> '/sidekiq-secrets/minio/./secretkey'
    '/init-secrets/minio/./accesskey' -> '/sidekiq-secrets/minio/./accesskey'
    '/init-secrets/minio/.' -> '/sidekiq-secrets/minio/.'

```shell
(
  kubectl logs \
      $(kubectl get pod \
        -l app=sidekiq \
        --namespace=gitlab \
        -o name )\
   --namespace=gitlab \
   -c dependencies
) 2>&1
```

    + /scripts/set-config /var/opt/gitlab/templates /srv/gitlab/config
    /usr/lib/ruby/2.4.0/psych.rb:472:in `initialize': No such file or directory @ rb_sysopen - /srv/gitlab/config/sidekiq_queues.yml (Errno::ENOENT)
      from /usr/lib/ruby/2.4.0/psych.rb:472:in `open'
      from /usr/lib/ruby/2.4.0/psych.rb:472:in `load_file'
      from (erb):1:in `<main>'
      from /usr/lib/ruby/2.4.0/erb.rb:896:in `eval'
      from /usr/lib/ruby/2.4.0/erb.rb:896:in `result'
      from /scripts/set-config:22:in `block in <main>'
      from /scripts/set-config:18:in `each'
      from /scripts/set-config:18:in `<main>'
    Begin parsing .erb files from /var/opt/gitlab/templates
    Writing /srv/gitlab/config/resque.yml
    Writing /srv/gitlab/config/gitlab.yml
    Writing /srv/gitlab/config/database.yml
    Writing /srv/gitlab/config/sidekiq_queues.yml

```tmate

```
