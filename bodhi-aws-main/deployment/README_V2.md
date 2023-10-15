# Bodhi Core Setup Guide

Step by Step Guide for Bodhi Core Setup

### Steps to Configure AWS Assume Role account

 - Switch Role with ACCOUNT_ID and ROLE_NAME
 - Configure with 
      ```
      aws configure
      cd ~/.aws/credentials
      vim  ~/.aws/credentials # add the below configuration
      ```



#### Prep Phase

- aws configure. set access ID, secret, default-region, format(json)

```bas
aws configure
```


## Connect to cluster

```bash
# connect to cluster
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME>
```
**Optional (Assumable role)**
```
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME> --profile <ROLE_NAME>
```

##  Run Configuration Script
```bash
chmod +x ./scripts/setup-repo-mac.sh  
./scripts/setup-repo-mac.sh configuration/setup-config.conf
```

## Deploy the Argo & Secret Base
```bash
# Apply argo CD base
kustomize build distribution/argocd/base | kubectl apply -f -
#wait for the pods and then apply external-secrets app

kubectl create secret generic aws-credentials -n kube-system --from-literal=username="" --from-literal=password=""

kubectl apply -f distribution/argocd-applications/external-secrets-operator.yaml

kustomize build distribution/external-secrets | kubectl apply -f -
# wait for the pods then apply private-repo
kustomize build distribution/argocd/overlays/private-repo | kubectl apply -f -
```

### Run that in separate Terminal
```bash
# wait for the pods then confirm repo in ArgoCD dashbard using following details
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $ARGOCD_PASSWORD
# run port-forward in separate terminal and visit http://localhost:8080 to see ArgoCD dashboard
kubectl port-forward svc/argocd-server -n argocd 8080:443
# run in current terminal
argocd login localhost:8080 --insecure --username admin --password $ARGOCD_PASSWORD
# check the Repository under settings on ArgoCD Dashboard. it should be green.
```

### Build the CI/CD Argo Deployment of Bodhi

Ensure you have only enabled phase in distribution-template/kustomization.yaml. rest phases shoudl be commented out.

```bash
# push to Git
git add .
git commit -m <COMMIT_MESSAGE>
git push 
```

#  ArgoCD application
```bash
kubectl apply -f distribution/bodhi-core.yaml
# wait for all pods to be running
```

## Debugging application with Force sync to ArgoCD 

```
argocd app sync bodhi-forecast-ui 
argocd app sync bodhi-core
argocd app sync user-onboarding 
argocd app sync istio-operatoxwr
argocd app sync jupyter-web-app
```


##  User Onboarding
```bash
chmod +x ./scripts/setup-user-onboarding.sh  
./scripts/setup-user-onboarding.sh 
```


### Credentials  Info

```bash
# KEYCLOAK password
KEYCLOAK_PASSWORD=$(kubectl -n auth get secret keycloak-secret -o jsonpath="{.data.admin-password}" | base64 -d)
echo $KEYCLOAK_PASSWORD
# ARGOCD Password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $ARGOCD_PASSWORD
GRAFANA_PASSWORD=$(kubectl -n monitoring get secret grafana-admin-secret  -o jsonpath="{.data.admin-password}" | base64 -d)
echo $GRAFANA_PASSWORD
GRAFANA_USERNAME=$(kubectl -n monitoring get secret grafana-admin-secret  -o jsonpath="{.data.admin-user}" | base64 -d)
echo $GRAFANA_USERNAME
```
### to install externel-secrets
helm install external-secrets external-secrets/external-secrets -n kube-system --set webhook.port=9443
