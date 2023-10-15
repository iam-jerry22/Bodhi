# from NFS-client-provisioner

kustomize build base | kubectl apply -f -
kubectl apply -f mongo-pvc.yaml
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install mongodb-marketplace bitnami/mongodb \
--set global.storageClass=managed-nfs-storage \
--set replicaSet.enabled=true \
--set replicaCount=2 \
--set mongodbRootPassword=mongodb \
--set persistence.existingClaim=mongodb-pvc \
--set persistence.enabled=True
