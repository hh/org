export TIME_START=$(date)
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get install -y docker-ce docker-ce-cli containerd.io

apt-get install -y git gcc

curl -L https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -

export GOROOT=/usr/local/go/
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
go version

echo "Getting Kubernetes..."
go get k8s.io/kubernetes
echo "Getting Kubetest..."
go get k8s.io/test-infra
echo "Getting Kind..."
go get sigs.k8s.io/kind

cd ~/go/src/k8s.io/test-infra
go build
cp kubetest ../kubernetes
cd ../kubernetes
echo "Getting a cluster up with Kind..."echo "Getting a cluster up with Kind..."
kubetest --deployment=kind --kind-binary-version=build --provider=skeleton --build --up

echo "Check on the state of the cluster..."
ln -sf ~/.kube/kind-config-kind-kubetest ~/.kube/config
kubectl get nodes
kubectl get pods --all-namespaces 

export TIME_END=$(date)

echo "Setup time..."
echo $TIME_START
echo $TIME_END
