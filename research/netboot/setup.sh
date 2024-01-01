# Make sure current kubemacs has been downloaded
docker pull gcr.io/apisnoop/kubemacs:0.9.33
# Build the dnsmasq container locally for now
docker build -t ii/dnsmasq ./dnsmasq

# Run with EMAIL=me@my.net NAME="First Last" bash setup.sh
NAME=${NAME:-"Hippie Hacker"}
EMAIL=${EMAIL:-"hh@ii.coop"}
KIND_IMAGE="kindest/node:v1.17.0@sha256:9512edae126da271b66b990b6fff768fbb7cd786c7d39e86bdf55906352fdf62"
KIND_CONFIG="kind-cluster-config.yaml"
K8S_RESOURCES="k8s-resources.yaml"
DEFAULT_NS="ii"

kind create cluster --config $KIND_CONFIG --image $KIND_IMAGE

kind load docker-image --nodes kind-control-plane ii/dnsmasq
kind load docker-image --nodes kind-control-plane gcr.io/apisnoop/kubemacs:0.9.33

kubectl create ns $DEFAULT_NS
kubectl config set-context $(kubectl config current-context) --namespace=$DEFAULT_NS
kubectl apply -f ./.kubemacs

echo "Waiting for Kubemacs StatefulSet to have 1 ready Replica..."
while [ "$(kubectl get statefulset kubemacs -o json | jq .status.readyReplicas)" != 1 ]; do
  sleep 1s
done

sleep 5
kubectl wait --for=condition=Ready pod/kubemacs-0
kubectl wait --for=condition=Ready pod/kubemacs-0
kubectl exec -ti kubemacs-0 -- attach
