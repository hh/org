- [Promote 15 tests to get 22 more endpoints covered](#sec-1)
  - [Node: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1Node&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NodeStatus&showUntested=false&showConformanceTested=false), [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1Node&showUntested=false&showConformanceTested=false)](#sec-1-1)
  - [NodeStatus: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NodeStatus&showUntested=false&showConformanceTested=false)](#sec-1-2)
  - [Namespaced Endpoints: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedEndpoints&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedEndpoints&showUntested=false&showConformanceTested=false)](#sec-1-3)
  - [Namespace: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false)](#sec-1-4)
  - [Namespace: [list](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-listCoreV1Namespace&showUntested=false&showConformanceTested=false)](#sec-1-5)
  - [Namespaced PodEviction: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPodEviction&showUntested=false&showConformanceTested=false)](#sec-1-6)
  - [PostNamespacedServiceProxyWithPath: [connect](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-connectCoreV1PostNamespacedServiceProxyWithPath&showUntested=false&showConformanceTested=false)](#sec-1-7)
  - [PodForAllNamespaces: [list](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-listCoreV1PodForAllNamespaces&showUntested=false&showConformanceTested=false)](#sec-1-8)
  - [Namespaced PodStatus: [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1NamespacedPodStatus&showUntested=false&showConformanceTested=false&level=stable)](#sec-1-9)
  - [Namespaced PodTemplate: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPodTemplate&showUntested=false&showConformanceTested=false)](#sec-1-10)
  - [Namespaced ConfigMap: [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1NamespacedConfigMap&showUntested=false&showConformanceTested=false)](#sec-1-11)
  - [Namespaced LimitRange: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false&level=stable), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false&level=stable)](#sec-1-12)
  - [Namespaced ResourceQuota: [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedResourceQuota&showUntested=false&showConformanceTested=false&level=stable), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedResourceQuota&showUntested=false&showConformanceTested=false&level=stable)](#sec-1-13)
  - [Namespaced ReplicationControllerScale: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedReplicationControllerScale&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedReplicationControllerScale&showUntested=false&showConformanceTested=false)](#sec-1-14)
  - [Namespaced ServiceAccount: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedServiceAccount&showUntested=false&showConformanceTested=false)](#sec-1-15)
- [With a conformant PVCs testing solution we would get another 7 endpoints](#sec-2)
  - [Namespaced PersistentVolumeClaim: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false)](#sec-2-1)
  - [PersistentVolume: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1PersistentVolume&showUntested=false&showConformanceTested=false), [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1PersistentVolume&showUntested=false&showConformanceTested=false)](#sec-2-2)

# Promote 15 tests to get 22 more endpoints covered<a id="sec-1"></a>

APISnoop filtering to [tested but not conformant Stable/Core endpoints](https://apisnoop.cncf.io/?zoomed=category-stable-core&showUntested=false&showConformanceTested=false&level=stable) allows us to readily see 30 endpoints that have associated tests that could be promoted to increase coverage.

If we further filter to each of those 30 endpoints, we can see the exact tests associated with those endpoints.

## Node: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1Node&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NodeStatus&showUntested=false&showConformanceTested=false), [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1Node&showUntested=false&showConformanceTested=false)<a id="sec-1-1"></a>

-   [ ] [{k8s.io} {sig-node} kubelet {k8s.io} {sig-node} Clean up pods on node kubelet should be able to delete 10 pods per node in 1m0s.](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/node/kubelet.go#L252)

## NodeStatus: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NodeStatus&showUntested=false&showConformanceTested=false)<a id="sec-1-2"></a>

-   [ ] [{sig-scheduling} PreemptionExecutionPath runs ReplicaSets to verify preemption running path](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/scheduling/preemption.go#L463)

## Namespaced Endpoints: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedEndpoints&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedEndpoints&showUntested=false&showConformanceTested=false)<a id="sec-1-3"></a>

-   [ ] [{sig-storage} In-tree Volumes {Driver: gluster} {Testpattern: Inline-volume (default fs)} subPath should support existing directory](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/testsuites/subpath.go#L182)

## Namespace: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false)<a id="sec-1-4"></a>

-   [ ] [{sig-api-machinery} AdmissionWebhook Should honor timeout](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apimachinery/webhook.go#L236)

## Namespace: [list](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-listCoreV1Namespace&showUntested=false&showConformanceTested=false)<a id="sec-1-5"></a>

-   [ ] [{sig-storage} PersistentVolumes GCEPD should test that deleting the Namespace of a PVC and Pod causes the successful detach of Persistent Disk](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/persistent_volumes-gce.go#L152)

## Namespaced PodEviction: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPodEviction&showUntested=false&showConformanceTested=false)<a id="sec-1-6"></a>

-   [ ] [{sig-apps} DisruptionController should block an eviction until the PDB is updated to allow it](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apps/disruption.go#L201)

## PostNamespacedServiceProxyWithPath: [connect](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-connectCoreV1PostNamespacedServiceProxyWithPath&showUntested=false&showConformanceTested=false)<a id="sec-1-7"></a>

-   [ ] [{sig-autoscaling} {HPA} Horizontal pod autoscaling (scale resource: CPU) {sig-autoscaling} ReplicationController light Should scale from 1 pod to 2 pods](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/autoscaling/horizontal_pod_autoscaling.go#L70)

## PodForAllNamespaces: [list](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-listCoreV1PodForAllNamespaces&showUntested=false&showConformanceTested=false)<a id="sec-1-8"></a>

-   [ ] [{k8s.io} {sig-node} NodeProblemDetector {DisabledForLargeClusters} should run without error](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/node/node_problem_detector.go#L57)

## Namespaced PodStatus: [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1NamespacedPodStatus&showUntested=false&showConformanceTested=false&level=stable)<a id="sec-1-9"></a>

-   [ ] [{k8s.io} Pods should support pod readiness gates {NodeFeature:PodReadinessGate}](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/common/pods.go#L775)

## Namespaced PodTemplate: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPodTemplate&showUntested=false&showConformanceTested=false)<a id="sec-1-10"></a>

-   [ ] [{sig-api-machinery} Servers with support for API chunking should return chunks of results for list calls](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apimachinery/chunking.go#L78)
-   [ ] [{sig-api-machinery} Servers with support for Table transformation should return chunks of table results for list calls](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apimachinery/table_conversion.go#L78)

## Namespaced ConfigMap: [patch](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-patchCoreV1NamespacedConfigMap&showUntested=false&showConformanceTested=false)<a id="sec-1-11"></a>

<https://github.com/kubernetes/kubernetes/issues/78832>

-   [ ] [{sig-api-machinery} AdmissionWebhook Should be able to deny pod and configmap creation](https://github.com/kubernetes/kubernetes/blob/254781b9ecadb411767787f564ce10cc451cfaef/test/e2e/apimachinery/webhook.go#L133)

## Namespaced LimitRange: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false&level=stable), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedLimitRange&showUntested=false&showConformanceTested=false&level=stable)<a id="sec-1-12"></a>

-   [ ] [{sig-scheduling} LimitRange should create a LimitRange with defaults and ensure pod has those defaults applied.](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/scheduling/limit_range.go#L44)

## Namespaced ResourceQuota: [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedResourceQuota&showUntested=false&showConformanceTested=false&level=stable), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedResourceQuota&showUntested=false&showConformanceTested=false&level=stable)<a id="sec-1-13"></a>

<https://github.com/kubernetes/kubernetes/issues/78831>

-   [ ] [{sig-api-machinery} ResourceQuota Should be able to update and delete ResourceQuota.](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apimachinery/resource_quota.go#L753)
-   [ ] [{sig-api-machinery} ResourceQuota should create a ResourceQuota and capture the life of a custom resource.](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/apimachinery/resource_quota.go#L493)

## Namespaced ReplicationControllerScale: [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedReplicationControllerScale&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedReplicationControllerScale&showUntested=false&showConformanceTested=false)<a id="sec-1-14"></a>

-   [ ] [{sig-network} Services should create endpoints for unready pods](https://github.com/kubernetes/kubernetes/blob/68530b150c377d6ffae80e745a7080169789b948/test/e2e/network/service.go#L1253)

## Namespaced ServiceAccount: [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedServiceAccount&showUntested=false&showConformanceTested=false)<a id="sec-1-15"></a>

-   [ ] [{sig-auth} ServiceAccounts should ensure a single API token exists](https://github.com/kubernetes/kubernetes/blob/523b9516435d2c3b671a0d86fabec4a8dd7c7bc6/test/e2e/auth/service_accounts.go#L57)

# With a conformant PVCs testing solution we would get another 7 endpoints<a id="sec-2"></a>

## Namespaced PersistentVolumeClaim: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [replace](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-replaceCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-deleteCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false)<a id="sec-2-1"></a>

Promotion Issue: <https://github.com/kubernetes/kubernetes/issues/78830>

-   [ ] [{sig-storage} Volume expand should allow expansion of block volumes](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/volume_expand.go#L211)
-   [ ] [{sig-storage} Volume expand should resize volume when PVC is edited while pod is using it](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/volume_expand.go#L107)
-   [ ] [{sig-storage} Volume expand Verify if offline PVC expansion works](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/volume_expand.go#L107)
-   [ ] [{sig-storage} Volume expand should not allow expansion of pvcs without AllowVolumeExpansion property](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/volume_expand.go#L90)
-   [ ] [{sig-storage} Mounted volume expand Should verify mounted devices can be resized](https://github.com/kubernetes/kubernetes/blob/0e499be526bc91ad2d2e187428da12daa03a1eae/test/e2e/storage/mounted_volume_resize.go#L112)

## PersistentVolume: [create](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-createCoreV1PersistentVolume&showUntested=false&showConformanceTested=false), [read](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1NamespacedPersistentVolumeClaim&showUntested=false&showConformanceTested=false), [delete](https://apisnoop.cncf.io/?zoomed=operationId-stable-core-readCoreV1PersistentVolume&showUntested=false&showConformanceTested=false)<a id="sec-2-2"></a>
