kubectl get namespace ray -o json > ray.json
kubectl replace --raw "/api/v1/namespaces/ray/finalize" -f ./ray.json

kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --show-all --ignore-not-found -n ray

kubectl api-resources --verbs=list --namespaced -o name \
 | xargs -n 1 kubectl get --show-kind --ignore-not-found -n ray

kubectl get namespace ray -o yaml

kubectl get namespace ray -o json >ray.json

curl -k -H "Content-Type: application/json" -X PUT --data-binary @ray.json http://127.0.0.1:8001/api/v1/namespaces/ray/finalize

kubectl get rayclusters -n ray ray-example-cluster -o json > cluster.json

curl -k -H "Content-Type: application/json" -X PUT --data-binary @cluster.json http://127.0.0.1:8001/apis/cluster.ray.io/v1/namespaces/ray/rayclusters/ray-example-cluster/finalize

kubectl get crd -n ray rayclusters.cluster.ray.io -o json > tmp.json
/apis/apiextensions.k8s.io/v1/customresourcedefinitions/rayclusters.cluster.ray.io

curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://127.0.0.1:8001/apis/apiextensions.k8s.io/v1/customresourcedefinitions/rayclusters.cluster.ray.io/finalize

kubectl patch crd/rayclusters.cluster.ray.io -p '{"metadata":{"finalizers":[]}}' --type=merge

WORKED LIKE A CHARM !!
kubectl patch -n ray rayclusters/bodhi-ray-cluster -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch crd/rayclusters.cluster.ray.io -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch ns/ray -p '{"metadata":{"finalizers":[]}}' --type=merge
