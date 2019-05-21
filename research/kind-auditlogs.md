  - [kube-config.yaml pulled from artifacts](#sec-1)
  - [kubeadm config pulled from logs](#sec-2)
  - [error has occured](#sec-3)
  - [failed to start control plane](#sec-4)

# kube-config.yaml pulled from artifacts<a id="sec-1"></a>

```shell
  curl https://storage.googleapis.com\
/kubernetes-jenkins/pr-logs/pull/sigs.k8s.io_kind/457\
/pull-kind-conformance-parallel/1127097770943975426\
/artifacts/kind-config.yaml
```

```yaml
# config for 1 control plane node and 2 workers
# necessary for conformance
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
nodes:
# the control plane node / apiservers
- role: control-plane
- role: worker
- role: worker
  extraMounts:
  - hostPath: /tmp/audit-policy.yaml
    containerPath: /etc/kubernetes/audit-policy.yaml
  - hostPath: "/workspace/_artifacts/apiserver-audit.log"
    containerPath: /var/log/apiserver-audit.log
kubeadmConfigPatches:
- |
  # v1beta1 works for 1.14+
  apiVersion: kubeadm.k8s.io/v1beta1
  kind: ClusterConfiguration
  metadata:
    name: config
  apiServer:
    extraArgs:
      audit-log-path: /var/log/apiserver-audit.log
      audit-policy-file: /etc/kubernetes/audit-policy.yaml
    extraVolumes:
    - name: auditpolicy
      pathType: File
      readOnly: true
      hostPath: /etc/kubernetes/audit-policy.yaml
      mountPath: /etc/kubernetes/audit-policy.yaml
    - name: auditlog
      pathType: File
      readOnly: false
      hostPath: /var/log/apiserver-audit.log
      mountPath: /var/log/apiserver-audit.log
```

# kubeadm config pulled from logs<a id="sec-2"></a>

```shell
  # The prow url only works while the job is active in the cluster
  #curl 'https://prow.k8s.io/log?job=pull-kind-conformance-parallel&id=1127097770943975426' \
  curl https://storage.googleapis.com\
/kubernetes-jenkins/pr-logs/pull/sigs.k8s.io_kind/457\
/pull-kind-conformance-parallel/1127097770943975426\
/build-log.txt \
  | grep 06:37:29.307 \
  | awk -F\" '{print $4,$5,$6}' \
  | sed 's:.*msg=\"::g' \
  | sed 's:\\n:\n:g' \
  | grep -v 'Using kubeadm config:' \
  | cat
```

```yaml
apiServer:
  certSANs:
  - localhost
  extraArgs:
    audit-log-path: /var/log/apiserver-audit.log
    audit-policy-file: /etc/kubernetes/audit-policy.yaml
  extraVolumes:
  - hostPath: /etc/kubernetes/audit-policy.yaml
    mountPath: /etc/kubernetes/audit-policy.yaml
    name: auditpolicy
    pathType: File
    readOnly: true
  - hostPath: /var/log/apiserver-audit.log
    mountPath: /var/log/apiserver-audit.log
    name: auditlog
    pathType: File
    readOnly: false
apiVersion: kubeadm.k8s.io/v1beta1
clusterName: kind
controllerManager:
  extraArgs:
    enable-hostpath-provisioner: \ true\ 
kind: ClusterConfiguration
kubernetesVersion: v1.15.0-alpha.3.238+b4d2cb0001cc27
name: config
---
apiVersion: kubeadm.k8s.io/v1beta1
bootstrapTokens:
- token: abcdef.0123456789abcdef
kind: InitConfiguration
localAPIEndpoint:
  bindPort: 6443
nodeRegistration:
  criSocket: /run/containerd/containerd.sock
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: JoinConfiguration
nodeRegistration:
  criSocket: /run/containerd/containerd.sock
---
apiVersion: kubelet.config.k8s.io/v1beta1
evictionHard:
  imagefs.available: 0%
  nodefs.available: 0%
  nodefs.inodesFree: 0%
imageGCHighThresholdPercent: 100
kind: KubeletConfiguration
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration

```

<https://gubernator.k8s.io/build/kubernetes-jenkins/pr-logs/pull/sigs.k8s.io_kind/457/pull-kind-conformance-parallel/1127097770943975426>

# error has occured<a id="sec-3"></a>

```shell
  curl https://storage.googleapis.com\
/kubernetes-jenkins/pr-logs/pull/sigs.k8s.io_kind/457\
/pull-kind-conformance-parallel/1127097770943975426\
/build-log.txt \
  | grep 'Unfortunately, an error has occurred' \
  | sed 's:.*msg=\"::g' \
  | sed 's:\\n:\n:g' \
  | grep -A20 'Unfortunately, an error has occurred' \
  | sed 's:\\t:  :g' \
  | cat
```

```yaml
Unfortunately, an error has occurred:
  timed out waiting for the condition

This error is likely caused by:
  - The kubelet is not running
  - The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)

If you are on a systemd-powered system, you can try to troubleshoot the error with the following commands:
  - 'systemctl status kubelet'
  - 'journalctl -xeu kubelet'

Additionally, a control plane component may have crashed or exited when started by the container runtime.
To troubleshoot, list all containers using your preferred container runtimes CLI, e.g. docker.
Here is one example how you may list all Kubernetes containers running in docker:
  - 'docker ps -a | grep kube | grep -v pause'
  Once you have found the failing container, you can inspect its logs with:
  - 'docker logs CONTAINERID'
error execution phase wait-control-plane: couldn't initialize a Kubernetes cluster"
```

# failed to start control plane<a id="sec-4"></a>

```shell
curl https://storage.googleapis.com/kubernetes-jenkins/pr-logs/pull/sigs.k8s.io_kind/457/pull-kind-conformance-parallel/1127097770943975426/build-log.txt \
| grep '06:41:38' \
| sed 's:.*msg=\"::g' \
| sed 's:\\n:\n:g' \
| sed 's:\\t:  :g' \
| grep '06:41:38.417\|06:41:38.518' \
| cat
```

```yaml
I0511 06:41:38.417]  ✗ Starting control-plane 🕹️
W0511 06:41:38.518] Error: failed to create cluster: failed to init node with kubeadm: exit status 1
W0511 06:41:38.518] + cleanup
W0511 06:41:38.518] + kind export logs /workspace/_artifacts/logs
```
