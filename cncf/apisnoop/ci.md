- [Overview](#sec-1)
  - [Mirror => Pipelines => Jobs => Environments](#sec-1-1)
  - [Example](#sec-1-2)
  - [Basics of using review/BRANCH deployment](#sec-1-3)
- [Kubernetes Cluster Overview](#sec-2)
  - [namespaces](#sec-2-1)
  - [gitlab-managed-apps namespace](#sec-2-2)
    - [everything](#sec-2-2-1)
  - [our project namespace](#sec-2-3)
  - [project pods](#sec-2-4)
    - [current review pod](#sec-2-4-1)
- [Digging into an environment / deployment](#sec-3)
  - [gitlab environments => k8s deployments](#sec-3-1)
  - [gitlab environment => pod](#sec-3-2)
    - [executing commands / listing data within pod](#sec-3-2-1)
    - [review pod details](#sec-3-2-2)
  - [kubectl exec shell](#sec-3-3)
- [Debugging a build](#sec-4)
  - [retrieving the trace](#sec-4-1)
  - [build container](#sec-4-2)
  - [repository image](#sec-4-3)
- [TIL](#sec-5)
  - [retreving cluster creds](#sec-5-1)
  - [retreiving a job trace](#sec-5-2)
  - [retrieving a job ENV](#sec-5-3)
  - [run kubectl commands within deploy job](#sec-5-4)
- [<code>[0/1]</code> Future Features](#sec-6)


# Overview<a id="sec-1"></a>

Our software developers needed to work on multiple issues / branches at the same time. We needed to be able to compare different data generation methods and visualizations. We have explored a few options (static sites via netflify, and various CI providers), but feel our workflow with GitLab worth sharing.

## Mirror => Pipelines => Jobs => Environments<a id="sec-1-1"></a>

We mirror from our repo to a CI-only Gitlab project:

-   [settings/repository/mirroring](https://gitlab.ii.coop/apisnoop/ci/settings/repository)

Each commit on a branch triggers a pipeline, and a set of jobs:

-   [branches](https://gitlab.ii.coop/apisnoop/ci/branches) => [pipelines](https://gitlab.ii.coop/apisnoop/ci/pipelines) => [jobs](https://gitlab.ii.coop/apisnoop/ci/-/jobs)

The deploy jobs create environments per branch:

-   [environments](https://gitlab.ii.coop/apisnoop/ci/environments) => [review/\*branch\*](https://gitlab.ii.coop/apisnoop/ci/environments/folders/review)

## Example<a id="sec-1-2"></a>

Example commit pipeline to deploy

-   [UAFilter-commit](https://gitlab.ii.coop/apisnoop/ci/commit/eccfa3ce17d457754ee1d544910aeea22d2af600)
-   [pipeline#281](https://gitlab.ii.coop/apisnoop/ci/pipelines/281)
-   [build](https://gitlab.ii.coop/apisnoop/ci/-/jobs/1871) and [deploy](https://gitlab.ii.coop/apisnoop/ci/-/jobs/1872) jobs
-   [environment](https://gitlab.ii.coop/apisnoop/ci/environments/42)
-   [console](https://gitlab.ii.coop/apisnoop/ci/environments/42/terminal)
-   [apisnoop-ci-review-BRANCHNAME.apisnoop.cncf.ci](https://apisnoop-ci-review-tix-121-ltf42v.apisnoop.cncf.ci/)

## Basics of using review/BRANCH deployment<a id="sec-1-3"></a>

We also have a Prow bot (@cncf-ci) watching our upstream repo on Github. When a new pull request is created, the bot will respond with pipeline results.

Flow is as follows:

-   [X] Create a PR
-   [X] Wait for @cncf-ci to respond with your pipeline results
-   [X] Inspect Pipeline logs and visit deployment url

# Kubernetes Cluster Overview<a id="sec-2"></a>

<https://gitlab.ii.coop/apisnoop/ci/clusters/23>

## namespaces<a id="sec-2-1"></a>

Jobs running in the `gitlab-managed-apps` namespace created/manage the `apisnoop-ci` namespace.

```shell
kubectl get namespaces
```

    NAME                  STATUS   AGE
    apisnoop-ci           Active   1d
    default               Active   11d
    gitlab-managed-apps   Active   11d
    kube-public           Active   11d
    kube-system           Active   11d
    openfisca-aotearoa    Active   7d
    raputure              Active   7d

## gitlab-managed-apps namespace<a id="sec-2-2"></a>

The job runners and CI infrastructure not specific to our project run in the `gitlab-managed-apps` namespace.

```shell
kubectl --namespace=gitlab-managed-apps get pods | grep -v rror
```

    NAME                                                     READY   STATUS    RESTARTS   AGE
    certmanager-cert-manager-6c8cd9f9bf-kjjsq                1/1     Running   3          11d
    ingress-nginx-ingress-controller-ff666c548-vgcjr         1/1     Running   0          11d
    ingress-nginx-ingress-default-backend-6679dd498c-nqh7p   1/1     Running   0          11d
    prometheus-kube-state-metrics-8668948654-6qj5m           1/1     Running   0          11d
    prometheus-prometheus-server-746bb67956-dzxz9            2/2     Running   0          11d
    runner-gitlab-runner-9df899f44-smgtx                     1/1     Running   0          11d
    tiller-deploy-9768f6964-qtb9m                            1/1     Running   0          11d

### everything<a id="sec-2-2-1"></a>

```shell
kubectl --namespace=gitlab-managed-apps get all | grep -v Error
```

    NAME                                                         READY   STATUS    RESTARTS   AGE
    pod/certmanager-cert-manager-6c8cd9f9bf-kjjsq                1/1     Running   3          11d
    pod/ingress-nginx-ingress-controller-ff666c548-vgcjr         1/1     Running   0          11d
    pod/ingress-nginx-ingress-default-backend-6679dd498c-nqh7p   1/1     Running   0          11d
    pod/prometheus-kube-state-metrics-8668948654-6qj5m           1/1     Running   0          11d
    pod/prometheus-prometheus-server-746bb67956-dzxz9            2/2     Running   0          11d
    pod/runner-gitlab-runner-9df899f44-smgtx                     1/1     Running   0          11d
    pod/tiller-deploy-9768f6964-qtb9m                            1/1     Running   0          11d
    NAME                                             TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
    service/ingress-nginx-ingress-controller         LoadBalancer   10.15.251.145   35.244.71.53   80:32363/TCP,443:30587/TCP   11d
    service/ingress-nginx-ingress-controller-stats   ClusterIP      10.15.240.235   <none>         18080/TCP                    11d
    service/ingress-nginx-ingress-default-backend    ClusterIP      10.15.243.113   <none>         80/TCP                       11d
    service/prometheus-kube-state-metrics            ClusterIP      None            <none>         80/TCP                       11d
    service/prometheus-prometheus-server             ClusterIP      10.15.254.80    <none>         80/TCP                       11d
    service/tiller-deploy                            ClusterIP      10.15.253.242   <none>         44134/TCP                    11d
    NAME                                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/certmanager-cert-manager                1         1         1            1           11d
    deployment.apps/ingress-nginx-ingress-controller        1         1         1            1           11d
    deployment.apps/ingress-nginx-ingress-default-backend   1         1         1            1           11d
    deployment.apps/prometheus-kube-state-metrics           1         1         1            1           11d
    deployment.apps/prometheus-prometheus-server            1         1         1            1           11d
    deployment.apps/runner-gitlab-runner                    1         1         1            1           11d
    deployment.apps/tiller-deploy                           1         1         1            1           11d
    NAME                                                               DESIRED   CURRENT   READY   AGE
    replicaset.apps/certmanager-cert-manager-6c8cd9f9bf                1         1         1       11d
    replicaset.apps/ingress-nginx-ingress-controller-ff666c548         1         1         1       11d
    replicaset.apps/ingress-nginx-ingress-default-backend-6679dd498c   1         1         1       11d
    replicaset.apps/prometheus-kube-state-metrics-8668948654           1         1         1       11d
    replicaset.apps/prometheus-prometheus-server-746bb67956            1         1         1       11d
    replicaset.apps/runner-gitlab-runner-9df899f44                     1         1         1       11d
    replicaset.apps/tiller-deploy-9768f6964                            1         1         1       11d

## our project namespace<a id="sec-2-3"></a>

Our `apisnoop-ci` namespace contains our deployments based on environment/branches.

```shell
kubectl --namespace=apisnoop-ci get all 
```

    NAME                                         READY   STATUS    RESTARTS   AGE
    pod/cm-acme-http-solver-f7cz7                1/1     Running   0          15h
    pod/cm-acme-http-solver-qb8lg                1/1     Running   0          13h
    pod/production-fb874dbcc-h5z7s               1/1     Running   0          15h
    pod/review-tix-121-ltf42v-7cfd94d94c-qcbmv   1/1     Running   0          12h
    pod/staging-dccc64786-bhhhj                  1/1     Running   0          13h
    NAME                                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
    service/cm-acme-http-solver-b24bq           NodePort    10.15.252.244   <none>        8089:32093/TCP   15h
    service/cm-acme-http-solver-qj9wq           NodePort    10.15.255.153   <none>        8089:32489/TCP   13h
    service/production-auto-deploy              ClusterIP   10.15.246.231   <none>        5000/TCP         15h
    service/review-tix-121-ltf42v-auto-deploy   ClusterIP   10.15.245.117   <none>        5000/TCP         14h
    service/staging-auto-deploy                 ClusterIP   10.15.250.73    <none>        5000/TCP         21h
    NAME                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/production              1         1         1            1           15h
    deployment.apps/review-tix-121-ltf42v   1         1         1            1           14h
    deployment.apps/staging                 1         1         1            1           21h
    NAME                                               DESIRED   CURRENT   READY   AGE
    replicaset.apps/production-fb874dbcc               1         1         1       15h
    replicaset.apps/review-tix-121-ltf42v-567ccfb9dc   0         0         0       12h
    replicaset.apps/review-tix-121-ltf42v-588c574d9f   0         0         0       14h
    replicaset.apps/review-tix-121-ltf42v-7cfd94d94c   1         1         1       12h
    replicaset.apps/review-tix-121-ltf42v-8f4c798c6    0         0         0       13h
    replicaset.apps/staging-56b4657fbd                 0         0         0       18h
    replicaset.apps/staging-7d78c78465                 0         0         0       21h
    replicaset.apps/staging-85df9ccbb9                 0         0         0       15h
    replicaset.apps/staging-dccc64786                  1         1         1       13h

## project pods<a id="sec-2-4"></a>

```shell
kubectl --namespace=apisnoop-ci get pods 
```

    NAME                                     READY   STATUS    RESTARTS   AGE
    cm-acme-http-solver-f7cz7                1/1     Running   0          18h
    cm-acme-http-solver-qb8lg                1/1     Running   0          16h
    production-fb874dbcc-h5z7s               1/1     Running   0          18h
    review-tix-121-ltf42v-7cfd94d94c-qcbmv   1/1     Running   0          15h
    staging-dccc64786-bhhhj                  1/1     Running   0          16h

### current review pod<a id="sec-2-4-1"></a>

\#+NAME review pod

```shell
kubectl describe --namespace=apisnoop-ci pod/review-tix-121-ltf42v-7cfd94d94c-qcbmv
```

    Name:               review-download-f-5nlwri-688f86cc9c-vk22s
    Namespace:          apisnoop-ci
    Priority:           0
    PriorityClassName:  <none>
    Node:               gke-apisnoop-ci-default-pool-3fb18c85-whd7/10.152.0.13
    Start Time:         Tue, 26 Mar 2019 09:44:28 +1300
    Labels:             app=review-download-f-5nlwri
                        pod-template-hash=2449427757
                        release=review-download-f-5nlwri
                        tier=web
                        track=stable
    Annotations:        checksum/application-secrets: 
    Status:             Pending
    IP:                 
    Controlled By:      ReplicaSet/review-download-f-5nlwri-688f86cc9c
    Containers:
      auto-deploy-app:
        Container ID:   
        Image:          registry.ii.coop/apisnoop/ci/download-fix:50db9d03ac86e85a5f5dcf1d5a6a11a7ce65c16d
        Image ID:       
        Port:           5000/TCP
        Host Port:      0/TCP
        State:          Waiting
          Reason:       ContainerCreating
        Ready:          False
        Restart Count:  0
        Liveness:       http-get http://:5000/ delay=15s timeout=15s period=10s #success=1 #failure=3
        Readiness:      http-get http://:5000/ delay=5s timeout=3s period=10s #success=1 #failure=3
        Environment Variables from:
          review-download-f-5nlwri-secret  Secret  Optional: false
        Environment:
          DATABASE_URL:  postgres://user:testing-password@review-download-f-5nlwri-postgres:5432/review-download-f-5nlwri
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-xsmbr (ro)
    Conditions:
      Type              Status
      Initialized       True 
      Ready             False 
      ContainersReady   False 
      PodScheduled      True 
    Volumes:
      default-token-xsmbr:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-xsmbr
        Optional:    false
    QoS Class:       BestEffort
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type    Reason     Age    From                                                 Message
      ----    ------     ----   ----                                                 -------
      Normal  Scheduled  5m1s   default-scheduler                                    Successfully assigned apisnoop-ci/review-download-f-5nlwri-688f86cc9c-vk22s to gke-apisnoop-ci-default-pool-3fb18c85-whd7
      Normal  Pulling    4m57s  kubelet, gke-apisnoop-ci-default-pool-3fb18c85-whd7  pulling image "registry.ii.coop/apisnoop/ci/download-fix:50db9d03ac86e85a5f5dcf1d5a6a11a7ce65c16d"

# Digging into an environment / deployment<a id="sec-3"></a>

-   Production, Staging, Review/Branch

<https://gitlab.ii.coop/apisnoop/ci/environments>

-   Focus on Review/Branch

<https://gitlab.ii.coop/apisnoop/ci/environments/folders/review>

-   Choose your environment, rollback to prior deployments if need be

<https://gitlab.ii.coop/apisnoop/ci/environments/42>

-   If you been designated access, you can get a shell

<https://gitlab.ii.coop/apisnoop/ci/environments/42/terminal>

## gitlab environments => k8s deployments<a id="sec-3-1"></a>

```shell
kubectl --namespace=apisnoop-ci get deployments
```

    NAME                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    production              1         1         1            1           15h
    review-tix-121-ltf42v   1         1         1            1           15h
    staging                 1         1         1            1           21h

## gitlab environment => pod<a id="sec-3-2"></a>

```shell
kubectl --namespace=apisnoop-ci get pods -o=name | grep review
```

    pod/review-tix-121-ltf42v-7cfd94d94c-qcbmv

### executing commands / listing data within pod<a id="sec-3-2-1"></a>

```shell
kubectl --namespace=apisnoop-ci exec \
    review-tix-121-ltf42v-7cfd94d94c-qcbmv \
    -- \
   find /app/data-gen/processed/ -name apisnoop.json
```

    /app/data-gen/processed/ci-kubernetes-e2e-gce-cos-k8sstable2-default/2010/apisnoop.json
    /app/data-gen/processed/ci-kubernetes-e2e-gce-cos-k8sstable1-default/5953/apisnoop.json
    /app/data-gen/processed/ci-kubernetes-e2e-gci-gce/36092/apisnoop.json
    /app/data-gen/processed/ci-kubernetes-e2e-gce-cos-k8sbeta-default/10141/apisnoop.json
    /app/data-gen/processed/ci-kubernetes-e2e-gce-cos-k8sstable3-default/507/apisnoop.json

### review pod details<a id="sec-3-2-2"></a>

```shell
kubectl --namespace=apisnoop-ci describe pod/review-tix-121-ltf42v-7cfd94d94c-qcbmv
```

    Name:               review-tix-121-ltf42v-7cfd94d94c-qcbmv
    Namespace:          apisnoop-ci
    Priority:           0
    PriorityClassName:  <none>
    Node:               gke-apisnoop-ci-default-pool-3fb18c85-whd7/10.152.0.13
    Start Time:         Tue, 26 Mar 2019 16:27:03 +1300
    Labels:             app=review-tix-121-ltf42v
                        pod-template-hash=3798508507
                        release=review-tix-121-ltf42v
                        tier=web
                        track=stable
    Annotations:        checksum/application-secrets: 
    Status:             Running
    IP:                 10.12.0.63
    Controlled By:      ReplicaSet/review-tix-121-ltf42v-7cfd94d94c
    Containers:
      auto-deploy-app:
        Container ID:   docker://ed96e9bf14e98d0209eddf37441cc6247bbdb7fa8bb2f276a40a2dcf952c0526
        Image:          registry.ii.coop/apisnoop/ci/tix-121:eccfa3ce17d457754ee1d544910aeea22d2af600
        Image ID:       docker-pullable://registry.ii.coop/apisnoop/ci/tix-121@sha256:e5d9f126cbd605b8ddbdda0d302205fc8fdd1383c4c2c7af177960e1f3d77e1f
        Port:           5000/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Tue, 26 Mar 2019 16:31:55 +1300
        Ready:          True
        Restart Count:  0
        Liveness:       http-get http://:5000/ delay=15s timeout=15s period=10s #success=1 #failure=3
        Readiness:      http-get http://:5000/ delay=5s timeout=3s period=10s #success=1 #failure=3
        Environment Variables from:
          review-tix-121-ltf42v-secret  Secret  Optional: false
        Environment:
          DATABASE_URL:  postgres://user:testing-password@review-tix-121-ltf42v-postgres:5432/review-tix-121-ltf42v
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-xsmbr (ro)
    Conditions:
      Type              Status
      Initialized       True 
      Ready             True 
      ContainersReady   True 
      PodScheduled      True 
    Volumes:
      default-token-xsmbr:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-xsmbr
        Optional:    false
    QoS Class:       BestEffort
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:          <none>

## kubectl exec shell<a id="sec-3-3"></a>

```tmate
kubectl --namespace=apisnoop-ci exec -ti \
      review-tix-121-ltf42v-7cfd94d94c-qcbmv \
      /bin/bash
```

```tmate
cd /app/data-gen/processed
```

# Debugging a build<a id="sec-4"></a>

## retrieving the trace<a id="sec-4-1"></a>

These files look to be in the wrong location:

<https://gitlab.ii.coop/apisnoop/ci/-/jobs/1802>

The herokuish runs against a dind:

```shell
export DOCKER_HOST=tcp://localhost:2375
docker exec -ti ci_job_build_1802 /bin/bash
```

```shell
. .env
curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.ii.coop/api/v4/projects/apisnoop%2Fci/jobs/1802/trace"
```

For some reason it's showing we aren't logged into the namespace

<https://gitlab.ii.coop/apisnoop/ci/-/jobs/1786>

```shell
. .env
curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.ii.coop/api/v4/projects/apisnoop%2Fci/jobs/1786/trace" \
| grep -A2 ensure_namespace
```

    [32;1m$ ensure_namespace[0;m
    error: You must be logged in to the server (Unauthorized)
    error: You must be logged in to the server (Unauthorized)

## build container<a id="sec-4-2"></a>

```shell
kubectl --namespace=gitlab-managed-apps get pods | grep 142 | awk '{print $1}'
```

    runner-zf8zf8jb-project-142-concurrent-02pzqk

```shell
(
  kubectl --namespace=gitlab-managed-apps logs \
        runner-zf8zf8jb-project-142-concurrent-02pzqk \
          -c build
) 2>&1
:
```

    

```tmate
kubectl --namespace=gitlab-managed-apps exec -ti \
        runner-zf8zf8jb-project-142-concurrent-02pzqk \
        -c build /bin/sh
```

We need to choose a specific container:

    Error from server (BadRequest):
    a container name must be specified for pod runner-zf8zf8jb-project-142-concurrent-0csdmb,
     choose one of: [build helper svc-0]

## repository image<a id="sec-4-3"></a>

The build job log will contain the registry + tag the image was pushed to.

    Configuring registry.ii.coop/apisnoop/ci/master:c2351d87cc36f0a1ef117c4caff3851312d514e6 docker image...

If you want to poke around the resulting image you can run the following:

```shell
docker pull registry.ii.coop/apisnoop/ci/master:c2351d87cc36f0a1ef117c4caff3851312d514e6
```

# TIL<a id="sec-5"></a>

Delete Environments

```shell
. .env
curl --request DELETE --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" \
  "https://gitlab.ii.coop/api/v4/projects/142/environments/40"
```

## retreving cluster creds<a id="sec-5-1"></a>

```shell
kubectl config view --merge --minify --flatten \
| grep -v access-token
```

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDekNDQWZPZ0F3SUJBZ0lRT0J3VEwvck15ZWNDczRyTFk5WTRRVEFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlSbU9UUm1OelZoTnkxa04yWmtMVFJoTURrdE9UYzBZeTAyT0RGa01qVTBOR0pqTWpjdwpIaGNOTVRrd016RTFNVFl4TWpBMFdoY05NalF3TXpFek1UY3hNakEwV2pBdk1TMHdLd1lEVlFRREV5Um1PVFJtCk56VmhOeTFrTjJaa0xUUmhNRGt0T1RjMFl5MDJPREZrTWpVME5HSmpNamN3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURBWnJIeUllbnBDUERZcmdmTjFYNFd0NmYvUTF1K2doUm5OTFdhaDBtaAp5L29YdDJtQmk4VWU2anpQeXJzdkRWd3FpSGVrMkoxTjJOT0hKWW1RQjdiRCs1ekVERWVaQnc5b2dBcWI3REtFClNVUCtsaE5FTGhTYUF0dHpRVzBEUjdPUlRlRmp0V0pJejNZZmg4dVlMMy9kTWFCa0xMNHlNMjhPb0YyRjN2YzcKL1dLUmdsNDUvd2VleUwvc0NjVmQwYW50R1BlUDZJNXRyRC9kRVZpRUo2UWkzYzlIU01CTkE0MFFBcTRuSFpZZAozV01QWkhoRmNKZ2hTTjZxZmVkMUdzc25XdmFMWGNBL2VlVUowVVI0ZnFkTUJVQU5zd0VTS1lLQTg4M1ZNczdJCjUrZHljdHFPbUcvd29LUUJzcFpDcHI3RXJybDlTcktOUHJXNDlTRXF4eU9oQWdNQkFBR2pJekFoTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFCdgoybzZqQ285TDcyZFllSUFCS1JsQlAxQU9VdzcrOXFtYjV0Y0JyTU11aW5pOEc1Y1lzaDRzUXNGZnZERVNMaldnCmFBSU1uVHEySm4yUnZOUTVJdkhZNllVU3k3MXh3bndBUnhGN2wyVHptVUZ3NFhlVG0xWTMzakFobmhnNE5GNWgKblRoek4wc2dSbVJrRzkwL1BuTUdTYkpYTzFob0pTL1ViWTVsbkU2ak93WFlWNnVTREM4cE41dHZ4MTlSWS9JVQo5TlBKRUp5a2I4VWF3WWIzS2pzV1JVdXBJTVprKzNIZ1lrT3lsbzE5SU9IRzdyTTNQV2pMbngrSTdGRlk3OXM1CnA1K3RUWUhhbDdyVEpIQTN1dFdzODJRc1J0RE9XbFczN0JKcEk5VWRCb1U3UmJYR3Z0VjcrV1NEM0dnbTNrZ20Kd2NiTEx2eUhWbnMycjRiWU9mbmoKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://35.201.3.241
  name: gke_apisnoop_australia-southeast1-c_apisnoop-ci
contexts:
- context:
    cluster: gke_apisnoop_australia-southeast1-c_apisnoop-ci
    user: gke_apisnoop_australia-southeast1-c_apisnoop-ci
  name: gke_apisnoop_australia-southeast1-c_apisnoop-ci
current-context: gke_apisnoop_australia-southeast1-c_apisnoop-ci
kind: Config
preferences: {}
users:
- name: gke_apisnoop_australia-southeast1-c_apisnoop-ci
  user:
    auth-provider:
      config:
        cmd-args: config config-helper --format=json
        cmd-path: /usr/lib/google-cloud-sdk/bin/gcloud
        expiry: "2019-03-26T16:41:26Z"
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
```

## retreiving a job trace<a id="sec-5-2"></a>

<https://docs.gitlab.com/ee/api/jobs.html#get-a-trace-file> <https://docs.gitlab.com/ee/api/README.html#namespaced-path-encoding>

```shell
. .env
curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.ii.coop/api/v4/projects/apisnoop%2Fci/jobs/1786/trace"
```

## retrieving a job ENV<a id="sec-5-3"></a>

We inspect the environment of pid 1 and use grep to sort it nicely

```shell
kubectl --namespace=gitlab-managed-apps exec -ti \
 runner-zf8zf8jb-project-142-concurrent-0dl4pg \
 -c build -- /bin/sh -c \
 'cat /proc/1/environ | grep =' | sort
```

    AUTO_DEVOPS_DOMAIN=apisnoop.cncf.ci
    CI_API_V4_URL=https://gitlab.ii.coop/api/v4
    CI_BUILD_BEFORE_SHA=ef143bd7e1583068b78cb2cf8d3be16d270e1cb4
    CI_BUILD_ID=1795
    CI_BUILD_NAME=review
    CI_BUILD_REF=1caf563c3cba6336036f867ae2d85fa4ee345718
    CI_BUILD_REF_NAME=gitlab-ci.yaml
    CI_BUILD_REF_SLUG=gitlab-ci-yaml
    CI_BUILD_STAGE=review
    CI_COMMIT_BEFORE_SHA=ef143bd7e1583068b78cb2cf8d3be16d270e1cb4
    CI_COMMIT_DESCRIPTION=
    CI_COMMIT_MESSAGE=Debugging .gitlab-ci.yml
    CI_COMMIT_REF_NAME=gitlab-ci.yaml
    CI_COMMIT_REF_SLUG=gitlab-ci-yaml
    CI_COMMIT_SHA=1caf563c3cba6336036f867ae2d85fa4ee345718
    CI_COMMIT_SHORT_SHA=1caf563c
    CI_COMMIT_TITLE=Debugging .gitlab-ci.yml
    CI_CONFIG_PATH=.gitlab-ci.yml
    CI_DISPOSABLE_ENVIRONMENT=true
    CI_ENVIRONMENT_NAME=review/gitlab-ci.yaml
    CI_ENVIRONMENT_SLUG=review-gitlab-ci-3s76v0
    CI_ENVIRONMENT_URL=http://apisnoop-ci-review-gitlab-ci-3s76v0.apisnoop.cncf.ci
    CI_JOB_ID=1795
    CI_JOB_NAME=review
    CI_JOB_STAGE=review
    CI_JOB_URL=https://gitlab.ii.coop/apisnoop/ci/-/jobs/1795
    CI_NODE_TOTAL=1
    CI_PIPELINE_ID=262
    CI_PIPELINE_IID=48
    CI_PIPELINE_SOURCE=push
    CI_PIPELINE_URL=https://gitlab.ii.coop/apisnoop/ci/pipelines/262
    CI_PROJECT_DIR=/apisnoop/ci
    CI_PROJECT_ID=142
    CI_PROJECT_NAME=ci
    CI_PROJECT_NAMESPACE=apisnoop
    CI_PROJECT_PATH=apisnoop/ci
    CI_PROJECT_PATH_SLUG=apisnoop-ci
    CI_PROJECT_URL=https://gitlab.ii.coop/apisnoop/ci
    CI_PROJECT_VISIBILITY=public
    CI_REGISTRY_IMAGE=registry.ii.coop/apisnoop/ci
    CI_REGISTRY=registry.ii.coop
    CI_REGISTRY_USER=gitlab-ci-token
    CI_RUNNER_DESCRIPTION=
    CI_RUNNER_EXECUTABLE_ARCH=linux/amd64
    CI_RUNNER_ID=6
    CI_RUNNER_REVISION=f100a208
    CI_RUNNER_TAGS=cluster, kubernetes
    CI_RUNNER_VERSION=11.6.0
    CI_SERVER_NAME=GitLab
    CI_SERVER_REVISION=ed04633
    CI_SERVER_TLS_CA_FILE=-----BEGIN CERTIFICATE-----
    CI_SERVER_VERSION=11.7.5-ee
    CI_SERVER_VERSION_MAJOR=11
    CI_SERVER_VERSION_MINOR=7
    CI_SERVER_VERSION_PATCH=5
    CI_SERVER=yes
    CI=true
    DOCKER_DRIVER=overlay2
    FF_K8S_USE_ENTRYPOINT_OVER_COMMAND=true
    GITLAB_CI=true
    GITLAB_FEATURES=audit_events,burndown_charts,code_owners,contribution_analytics,elastic_search,export_issues,group_burndown_charts,group_webhooks,issuable_default_templates,issue_board_focus_mode,issue_weights,jenkins_integration,ldap_group_sync,member_lock,merge_request_approvers,multiple_ldap_servers,multiple_issue_assignees,multiple_project_issue_boards,push_rules,project_creation_level,protected_refs_for_users,related_issues,repository_mirrors,repository_size_limit,scoped_issue_board,admin_audit_log,auditor_user,board_assignee_lists,board_milestone_lists,cross_project_pipelines,custom_file_templates,custom_file_templates_for_namespace,email_additional_text,db_load_balancing,deploy_board,extended_audit_events,file_locks,geo,github_project_service_integration,jira_dev_panel_integration,ldap_group_sync_filter,multiple_clusters,multiple_group_issue_boards,merge_request_performance_metrics,object_storage,group_saml,service_desk,smartcard_auth,unprotection_restrictions,variable_environment_scope,reject_unsigned_commits,commit_committer_check,external_authorization_service,ci_cd_projects,protected_environments,system_header_footer,custom_project_templates,packages,code_owner_as_approver_suggestion,feature_flags,batch_comments,issues_analytics,security_dashboard,dependency_scanning,license_management,sast,sast_container,container_scanning,cluster_health,dast,epics,chatops,pod_logs,pseudonymizer,prometheus_alerts,operations_dashboard,tracing,web_ide_terminal
    GITLAB_USER_EMAIL=hh@ii.coop
    GITLAB_USER_ID=2
    GITLAB_USER_LOGIN=hh
    GITLAB_USER_NAME=Hippie Hacker
    HELM_VERSION=2.11.0
    HOME=/root
    HOSTNAME=runner-zf8zf8jb-project-142-concurrent-0dl4pg
    INCREMENTAL_ROLLOUT_ENABLED=1
    INCREMENTAL_ROLLOUT_MODE=manual
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_443_TCP_ADDR=10.15.251.145
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_443_TCP_PORT=443
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_443_TCP_PROTO=tcp
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_443_TCP=tcp://10.15.251.145:443
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_80_TCP_ADDR=10.15.251.145
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_80_TCP_PORT=80
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_80_TCP_PROTO=tcp
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT_80_TCP=tcp://10.15.251.145:80
    INGRESS_NGINX_INGRESS_CONTROLLER_PORT=tcp://10.15.251.145:80
    INGRESS_NGINX_INGRESS_CONTROLLER_SERVICE_HOST=10.15.251.145
    INGRESS_NGINX_INGRESS_CONTROLLER_SERVICE_PORT=80
    INGRESS_NGINX_INGRESS_CONTROLLER_SERVICE_PORT_HTTP=80
    INGRESS_NGINX_INGRESS_CONTROLLER_SERVICE_PORT_HTTPS=443
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_PORT_18080_TCP_ADDR=10.15.240.235
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_PORT_18080_TCP_PORT=18080
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_PORT_18080_TCP_PROTO=tcp
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_PORT_18080_TCP=tcp://10.15.240.235:18080
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_PORT=tcp://10.15.240.235:18080
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_SERVICE_HOST=10.15.240.235
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_SERVICE_PORT=18080
    INGRESS_NGINX_INGRESS_CONTROLLER_STATS_SERVICE_PORT_STATS=18080
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_PORT_80_TCP_ADDR=10.15.243.113
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_PORT_80_TCP_PORT=80
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_PORT_80_TCP_PROTO=tcp
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_PORT_80_TCP=tcp://10.15.243.113:80
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_PORT=tcp://10.15.243.113:80
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_SERVICE_HOST=10.15.243.113
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_SERVICE_PORT=80
    INGRESS_NGINX_INGRESS_DEFAULT_BACKEND_SERVICE_PORT_HTTP=80
    KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
    KUBE_CA_PEM=-----BEGIN CERTIFICATE-----
    KUBE_CA_PEM_FILE=-----BEGIN CERTIFICATE-----
    KUBE_NAMESPACE=ci-142
    KUBERNETES_PORT_443_TCP_ADDR=10.15.240.1
    KUBERNETES_PORT_443_TCP_PORT=443
    KUBERNETES_PORT_443_TCP_PROTO=tcp
    KUBERNETES_PORT_443_TCP=tcp://10.15.240.1:443
    KUBERNETES_PORT=tcp://10.15.240.1:443
    KUBERNETES_SERVICE_HOST=10.15.240.1
    KUBERNETES_SERVICE_PORT=443
    KUBERNETES_SERVICE_PORT_HTTPS=443
    KUBERNETES_VERSION=1.10.9
    KUBE_SERVICE_ACCOUNT=ci-142-service-account
    KUBE_URL=https://35.201.3.241
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    POSTGRES_DB=review-gitlab-ci-3s76v0
    POSTGRES_ENABLED=true
    POSTGRES_PASSWORD=testing-password
    POSTGRES_USER=user
    PROMETHEUS_PROMETHEUS_SERVER_PORT_80_TCP_ADDR=10.15.254.80
    PROMETHEUS_PROMETHEUS_SERVER_PORT_80_TCP_PORT=80
    PROMETHEUS_PROMETHEUS_SERVER_PORT_80_TCP_PROTO=tcp
    PROMETHEUS_PROMETHEUS_SERVER_PORT_80_TCP=tcp://10.15.254.80:80
    PROMETHEUS_PROMETHEUS_SERVER_PORT=tcp://10.15.254.80:80
    PROMETHEUS_PROMETHEUS_SERVER_SERVICE_HOST=10.15.254.80
    PROMETHEUS_PROMETHEUS_SERVER_SERVICE_PORT=80
    PROMETHEUS_PROMETHEUS_SERVER_SERVICE_PORT_HTTP=80
    PWD=/
    SHLVL=1
    STAGING_ENABLED=1
    TILLER_DEPLOY_PORT_44134_TCP_ADDR=10.15.253.242
    TILLER_DEPLOY_PORT_44134_TCP_PORT=44134
    TILLER_DEPLOY_PORT_44134_TCP_PROTO=tcp
    TILLER_DEPLOY_PORT_44134_TCP=tcp://10.15.253.242:44134
    TILLER_DEPLOY_PORT=tcp://10.15.253.242:44134
    TILLER_DEPLOY_SERVICE_HOST=10.15.253.242
    TILLER_DEPLOY_SERVICE_PORT=44134
    TILLER_DEPLOY_SERVICE_PORT_TILLER=44134

## run kubectl commands within deploy job<a id="sec-5-4"></a>

I deleted the namespace, and apparently that was bad.

We wrap it in () and redirect stderr '2>&1' followed by : to ensure output staging-7d78c78465-w628j

```shell
(
    kubectl --namespace=gitlab-managed-apps exec \
        runner-zf8zf8jb-project-142-concurrent-0dl4pg \
        -c build -- \
        kubectl get namespaces
) 2>&1
:
```

    Error from server (Forbidden): namespaces is forbidden: User "system:serviceaccount:gitlab-managed-apps:default" cannot list namespaces at the cluster scope
    command terminated with exit code 1

# <code>[0/1]</code> Future Features<a id="sec-6"></a>

-   [ ] gitlab should provide the kubectl exec command to get a shell on a pod / container combo for a deploy
-   [ ] gitlab should provide links to line numbers in job output
