- [kube-\*](#sec-1)
  - [apiregistration](#sec-1-1)
    - [APIService](#sec-1-1-1)
  - [storage](#sec-1-2)
    - [VolumeAttachment](#sec-1-2-1)
  - [scheduling](#sec-1-3)
    - [PriorityClass](#sec-1-3-1)
  - [apps](#sec-1-4)
    - [ReplicaSet](#sec-1-4-1)
    - [StatefulSet](#sec-1-4-2)
  - [core](#sec-1-5)
    - [Endpoints](#sec-1-5-1)
    - [PersistentVolumeClaim](#sec-1-5-2)
    - [ResourceQuota](#sec-1-5-3)
    - [LimitRange](#sec-1-5-4)
    - [Secret](#sec-1-5-5)
    - [Service](#sec-1-5-6)
    - [Binding](#sec-1-5-7)
    - [Pod](#sec-1-5-8)
    - [ReplicationController](#sec-1-5-9)
    - [ServiceAccount](#sec-1-5-10)
  - [rbacAuthorization](#sec-1-6)
    - [ClusterRole](#sec-1-6-1)
    - [ClusterRoleBinding](#sec-1-6-2)
    - [Role](#sec-1-6-3)
    - [RoleBinding](#sec-1-6-4)
  - [networking](#sec-1-7)
    - [NetworkPolic](#sec-1-7-1)

# kube-\*<a id="sec-1"></a>

## apiregistration<a id="sec-1-1"></a>

### APIService<a id="sec-1-1-1"></a>

1.  replaceApiregistrationV1APIServiceStatus     :apiserver:

2.  listApiregistrationV1APIService     :apiserver:

## storage<a id="sec-1-2"></a>

### VolumeAttachment<a id="sec-1-2-1"></a>

1.  listStorageV1VolumeAttachment     :apiserver:ctlmgr:

2.  createStorageV1VolumeAttachment     :ctlmgr:

3.  readStorageV1VolumeAttachment     :ctlmgr:

4.  deleteStorageV1VolumeAttachment     :ctlmgr:

## scheduling<a id="sec-1-3"></a>

### PriorityClass<a id="sec-1-3-1"></a>

1.  listSchedulingV1PriorityClass     :apiserver:ctlmgr:

## apps<a id="sec-1-4"></a>

### ReplicaSet<a id="sec-1-4-1"></a>

1.  listAppsV1ReplicaSetForAllNamespaces     :scheduler:

### StatefulSet<a id="sec-1-4-2"></a>

## core<a id="sec-1-5"></a>

### Endpoints<a id="sec-1-5-1"></a>

1.  listCoreV1EndpointsForAllNamespaces     :apiserver:proxy:

### PersistentVolumeClaim<a id="sec-1-5-2"></a>

1.  listCoreV1PersistentVolumeClaimForAllNamespaces     :scheduler:

### ResourceQuota<a id="sec-1-5-3"></a>

1.  replaceCoreV1NamespacedResourceQuotaStatus     :apiserver:

2.  listCoreV1ResourceQuotaForAllNamespaces     :apiserver:

### LimitRange<a id="sec-1-5-4"></a>

1.  listCoreV1LimitRangeForAllNamespaces     :apiserver:

### Secret<a id="sec-1-5-5"></a>

1.  listCoreV1SecretForAllNamespaces     :apiserver:

### Service<a id="sec-1-5-6"></a>

1.  listCoreV1ServiceForAllNamespaces     :apiserver:proxy:scheduler:ctrlmgr:

### Binding<a id="sec-1-5-7"></a>

1.  createCoreV1NamespacedPodBinding     :scheduler:

### Pod<a id="sec-1-5-8"></a>

1.  replaceCoreV1NamespacedPodStatus     :scheduler:

### ReplicationController<a id="sec-1-5-9"></a>

1.  listCoreV1ReplicationControllerForAllNamespaces     :scheduler:

### ServiceAccount<a id="sec-1-5-10"></a>

1.  listCoreV1ServiceAccountForAllNamespaces     :apiserver:ctrlmgr:

2.  deleteCoreV1CollectionNamespacedServiceAccount     :ctrlmgr:

## rbacAuthorization<a id="sec-1-6"></a>

### ClusterRole<a id="sec-1-6-1"></a>

1.  readRbacAuthorizationV1ClusterRole     :apiserver:

2.  replaceRbacAuthorizationV1ClusterRole     :ctrlmgr:

### ClusterRoleBinding<a id="sec-1-6-2"></a>

1.  readRbacAuthorizationV1ClusterRoleBinding     :apiserver:

2.  listRbacAuthorizationV1ClusterRoleBinding     :apiserver:ctrlmgr:

### Role<a id="sec-1-6-3"></a>

1.  listRbacAuthorizationV1RoleForAllNamespaces     :apiserver:ctrlmgr:

2.  readRbacAuthorizationV1NamespacedRole     :apiserver:

3.  deleteRbacAuthorizationV1CollectionNamespacedRole     :ctrlmgr:

### RoleBinding<a id="sec-1-6-4"></a>

1.  listRbacAuthorizationV1RoleBindingForAllNamespaces     :apiserver:ctrlmgr:

2.  readRbacAuthorizationV1NamespacedRoleBinding     :apiserver:

3.  deleteRbacAuthorizationV1CollectionNamespacedRoleBinding     :ctrlmgr:

## networking<a id="sec-1-7"></a>

### NetworkPolic<a id="sec-1-7-1"></a>

1.  listNetworkingV1NetworkPolicyForAllNamespaces

2.  deleteNetworkingV1CollectionNamespacedNetworkPolicy
