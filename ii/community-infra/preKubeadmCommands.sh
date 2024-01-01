# Prepare
# The set of commands to prepare the Ubuntu installs for Kubernetes

#!/bin/bash
KUBERNETES_VERSION='1.21.2'

PACKAGES=(
  apt-transport-https
  ca-certificates
  cloud-utils
  containerd
  dnsutils
  ebtables
  gettext-base
  git
  jq
  kitty-terminfo
  prips
  socat
)

pwd
cd $(dirname $0)

# ensure mounts
sed -ri '/\\sswap\\s/s/^#?/#/' /etc/fstab
swapoff -a
mount -a

# install required packages
apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https curl software-properties-common
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
TRIMMED_KUBERNETES_VERSION=$(echo $KUBERNETES_VERSION | sed 's/\./\\./g' | sed 's/^v//')
RESOLVED_KUBERNETES_VERSION=$(apt-cache policy kubelet | awk -v VERSION=${TRIMMED_KUBERNETES_VERSION} '$1~ VERSION { print $1 }' | head -n1)
apt-get install -y ${PACKAGES[*]} \
  kubelet=${RESOLVED_KUBERNETES_VERSION} \
  kubeadm=${RESOLVED_KUBERNETES_VERSION} \
  kubectl=${RESOLVED_KUBERNETES_VERSION}
systemctl daemon-reload

# configure container runtime
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
mkdir -p /etc/containerd
rm /etc/containerd/config.toml
systemctl restart containerd
systemctl enable --now containerd
export CONTAINER_RUNTIME_ENDPOINT=/var/run/containerd/containerd.sock
echo $HOME
export HOME=$(getent passwd $(id -u) | cut -d ':' -f6)

# configure sysctls for Kubernetes
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system
systemctl enable --now systemd-resolved
systemctl disable snapd.service snapd.socket
