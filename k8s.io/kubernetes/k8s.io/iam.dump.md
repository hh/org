- [iam dump](#sec-1)
  - [exploring](#sec-1-1)
    - [list org projects](#sec-1-1-1)
  - [iam dump](#sec-1-2)
    - [CNCF org](#sec-1-2-1)
    - [kubernetes-public](#sec-1-2-2)
  - [TODO: which GROUPS have ROLES](#sec-1-3)
    - [CNCF org](#sec-1-3-1)
    - [kubernetes-public project](#sec-1-3-2)
  - [TODO: list buckets](#sec-1-4)
  - [TODO: dump iam for GCS buckets](#sec-1-5)
  - [TODO: list bigquer](#sec-1-6)
  - [TODO: dump iam for bigquery](#sec-1-7)
  - [TODO: look at tools that iterate over permissions](#sec-1-8)
  - [TODO: iterate over enabled APIs per project](#sec-1-9)


# iam dump<a id="sec-1"></a>

## exploring<a id="sec-1-1"></a>

### list org projects<a id="sec-1-1-1"></a>

```shell
gcloud projects list --filter "parent.id=758905017065" --format "value(name, projectId, projectNumber)"
```

    kubernetes-public	kubernetes-public	127754664067

## iam dump<a id="sec-1-2"></a>

### CNCF org<a id="sec-1-2-1"></a>

```shell
gcloud organizations get-iam-policy 758905017065
```

```yaml
bindings:
- members:
  - user:ihor@cncf.io
  - user:thockin@google.com
  - user:twaggoner@linuxfoundation.org
  role: roles/billing.admin
- members:
  - domain:kubernetes.io
  - user:ihor@cncf.io
  - user:thockin@google.com
  role: roles/billing.creator
- members:
  - user:hh@ii.coop
  role: roles/iam.securityReviewer
- members:
  - user:domain-admin-lf@kubernetes.io
  - user:ihor@cncf.io
  - user:thockin@google.com
  - user:twaggoner@linuxfoundation.org
  role: roles/resourcemanager.organizationAdmin
- members:
  - domain:kubernetes.io
  - user:thockin@google.com
  role: roles/resourcemanager.projectCreator
- members:
  - user:thockin@google.com
  role: roles/resourcemanager.projectDeleter
etag: BwWDl6w4hzc=
```

### kubernetes-public<a id="sec-1-2-2"></a>

```shell
gcloud projects get-iam-policy kubernetes-public
```

```yaml
bindings:
- members:
  - group:k8s-infra-cluster-admins@googlegroups.com
  role: projects/kubernetes-public/roles/ServiceAccountLister
- members:
  - group:k8s-infra-bigquery-admins@googlegroups.com
  role: roles/bigquery.admin
- members:
  - serviceAccount:service-127754664067@compute-system.iam.gserviceaccount.com
  role: roles/compute.serviceAgent
- members:
  - group:k8s-infra-cluster-admins@googlegroups.com
  role: roles/compute.viewer
- members:
  - group:k8s-infra-cluster-admins@googlegroups.com
  role: roles/container.admin
- members:
  - serviceAccount:service-127754664067@container-engine-robot.iam.gserviceaccount.com
  role: roles/container.serviceAgent
- members:
  - group:k8s-infra-dns-admins@googlegroups.com
  role: roles/dns.admin
- members:
  - serviceAccount:127754664067-compute@developer.gserviceaccount.com
  - serviceAccount:127754664067@cloudservices.gserviceaccount.com
  - serviceAccount:service-127754664067@containerregistry.iam.gserviceaccount.com
  role: roles/editor
- members:
  - serviceAccount:k8s-nodes@kubernetes-public.iam.gserviceaccount.com
  role: roles/logging.logWriter
- members:
  - serviceAccount:k8s-nodes@kubernetes-public.iam.gserviceaccount.com
  role: roles/monitoring.metricWriter
- members:
  - serviceAccount:k8s-nodes@kubernetes-public.iam.gserviceaccount.com
  role: roles/monitoring.viewer
- members:
  - user:domain-admin-lf@kubernetes.io
  - user:ihor@cncf.io
  - user:thockin@google.com
  role: roles/owner
etag: BwWBY6sq2cc=
version: 1
```

## TODO: which GROUPS have ROLES<a id="sec-1-3"></a>

### CNCF org<a id="sec-1-3-1"></a>

```shell
(
gcloud iam roles list --organization=758905017065
) 2>&1
```

    Listed 0 items.

### kubernetes-public project<a id="sec-1-3-2"></a>

```shell
gcloud --project=kubernetes-public iam roles list --format "value(name)"
```

    projects/kubernetes-public/roles/ServiceAccountLister

```shell
gcloud --project=kubernetes-public iam roles describe ServiceAccountLister --format "value(includedPermissions)"
```

    iam.serviceAccounts.list

## TODO: list buckets<a id="sec-1-4"></a>

```shell
gsutil ls -p kubernetes-public
```

    gs://kubernetes_public_billing/

```shell
gsutil ls -r gs://kubernetes_public_billing/
```

    gs://kubernetes_public_billing/billing--2019-01-10.csv
    gs://kubernetes_public_billing/billing--2019-01-11.csv
    gs://kubernetes_public_billing/billing--2019-01-12.csv
    gs://kubernetes_public_billing/billing--2019-01-13.csv
    gs://kubernetes_public_billing/billing--2019-01-14.csv
    gs://kubernetes_public_billing/billing--2019-01-15.csv
    gs://kubernetes_public_billing/billing--2019-01-16.csv
    gs://kubernetes_public_billing/billing--2019-01-17.csv
    gs://kubernetes_public_billing/billing--2019-01-18.csv
    gs://kubernetes_public_billing/billing--2019-01-19.csv
    gs://kubernetes_public_billing/billing--2019-01-20.csv
    gs://kubernetes_public_billing/billing--2019-01-21.csv
    gs://kubernetes_public_billing/billing--2019-01-22.csv
    gs://kubernetes_public_billing/billing--2019-01-23.csv
    gs://kubernetes_public_billing/billing--2019-01-24.csv
    gs://kubernetes_public_billing/billing--2019-01-25.csv
    gs://kubernetes_public_billing/billing--2019-01-26.csv
    gs://kubernetes_public_billing/billing--2019-01-27.csv
    gs://kubernetes_public_billing/billing--2019-01-28.csv
    gs://kubernetes_public_billing/billing--2019-01-29.csv
    gs://kubernetes_public_billing/billing--2019-01-30.csv
    gs://kubernetes_public_billing/billing--2019-01-31.csv
    gs://kubernetes_public_billing/billing--2019-02-01.csv
    gs://kubernetes_public_billing/billing--2019-02-02.csv
    gs://kubernetes_public_billing/billing--2019-02-03.csv
    gs://kubernetes_public_billing/billing--2019-02-04.csv
    gs://kubernetes_public_billing/billing--2019-02-05.csv
    gs://kubernetes_public_billing/billing--2019-02-06.csv
    gs://kubernetes_public_billing/billing--2019-02-07.csv
    gs://kubernetes_public_billing/billing--2019-02-08.csv
    gs://kubernetes_public_billing/billing--2019-02-09.csv
    gs://kubernetes_public_billing/billing--2019-02-10.csv
    gs://kubernetes_public_billing/billing--2019-02-11.csv
    gs://kubernetes_public_billing/billing--2019-02-12.csv
    gs://kubernetes_public_billing/billing--2019-02-13.csv
    gs://kubernetes_public_billing/billing--2019-02-14.csv
    gs://kubernetes_public_billing/billing--2019-02-15.csv
    gs://kubernetes_public_billing/billing--2019-02-16.csv
    gs://kubernetes_public_billing/billing--2019-02-17.csv
    gs://kubernetes_public_billing/billing--2019-02-18.csv
    gs://kubernetes_public_billing/billing--2019-02-19.csv
    gs://kubernetes_public_billing/billing--2019-02-20.csv
    gs://kubernetes_public_billing/billing--2019-02-21.csv
    gs://kubernetes_public_billing/billing--2019-02-22.csv
    gs://kubernetes_public_billing/billing--2019-02-23.csv
    gs://kubernetes_public_billing/billing--2019-02-24.csv
    gs://kubernetes_public_billing/billing--2019-02-25.csv
    gs://kubernetes_public_billing/billing--2019-02-26.csv
    gs://kubernetes_public_billing/billing--2019-02-27.csv
    gs://kubernetes_public_billing/billing--2019-02-28.csv
    gs://kubernetes_public_billing/billing--2019-03-01.csv
    gs://kubernetes_public_billing/billing--2019-03-02.csv
    gs://kubernetes_public_billing/billing--2019-03-03.csv
    gs://kubernetes_public_billing/billing--2019-03-04.csv
    gs://kubernetes_public_billing/billing--2019-03-05.csv
    gs://kubernetes_public_billing/billing--2019-03-06.csv
    gs://kubernetes_public_billing/billing--2019-03-07.csv

## TODO: dump iam for GCS buckets<a id="sec-1-5"></a>

for each GCS bucket in each project: dump IAM

## TODO: list bigquer<a id="sec-1-6"></a>

## TODO: dump iam for bigquery<a id="sec-1-7"></a>

for each bigquery dataset in each project: dump IAM

## TODO: look at tools that iterate over permissions<a id="sec-1-8"></a>

writing this from scratch MAY be fine, but a quick check might be nice if this gets too hairy

<https://github.com/marcin-kolda/gcp-iam-collector#features>

## TODO: iterate over enabled APIs per project<a id="sec-1-9"></a>

identify each resource, them dump iam
