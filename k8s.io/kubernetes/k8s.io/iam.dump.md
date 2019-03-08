- [iam dump](#sec-1)
  - [exploring](#sec-1-1)
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

```shell
gcloud projects list --filter "parent.id=758905017065" --format "value(name, projectId, projectNumber)"
```

## iam dump<a id="sec-1-2"></a>

### CNCF org<a id="sec-1-2-1"></a>

```shell
gcloud organizations get-iam-policy 758905017065
```

### kubernetes-public<a id="sec-1-2-2"></a>

```shell
gcloud projects get-iam-policy kubernetes-public
```

## TODO: which GROUPS have ROLES<a id="sec-1-3"></a>

### CNCF org<a id="sec-1-3-1"></a>

```shell
(
gcloud iam roles list --organization=758905017065
) 2>&1
```

### kubernetes-public project<a id="sec-1-3-2"></a>

```shell
gcloud --project=kubernetes-public iam roles list --format "value(name)"
```

```shell
gcloud --project=kubernetes-public iam roles describe ServiceAccountLister --format "value(includedPermissions)"
```

## TODO: list buckets<a id="sec-1-4"></a>

```shell
gsutil ls -p kubernetes-public
```

```shell
gsutil ls -r gs://kubernetes_public_billing/
```

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
