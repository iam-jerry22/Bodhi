# Bodhi Core Setup Guide

# Bodhi On AWS

## One click Infra Setup and Bodhi Application Deployment

Download the packages mentioned below:

- [Terraform](https://www.terraform.io/downloads)
- [Git](https://git-scm.com/download/mac)
- [aws]
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)

Clone the repository

```sh
git clone https://pscode.lioncloud.net/bodhi-platform/bodhi-aws.git
cd bodhi-aws
```

## Steps to Configure AWS account login

```bas
aws configure
```
- aws configure. It willl ask for the following details
```sh
AWS Access Key ID     = "<access_key Id of AWS Subscription>", 
AWS Secret Access Key = "<Secret access key of AWS Subscription", 
Default region name   = "<region name that you want your resources to be created>", eg: us-east-2 
Default output format = "" eg: json
```


Create "terraform.tfvars" (don't change this name) file in the below format, enter the details and Add the file inside infra folder

```sh

#Github Creds
github_repo_link = "<github_repo_link_where_the_argocd_will_sync_with>"
github_repo_branch = "<github_branch>"
github_username = "<github_username>"
github_password = "<github_password>"

#Website Domain
dns_zone = "<domain_name_where_bodhi_will_be_hosted>" #example- example.xyz



#Personal Creds
# prefix                = "<prefix to be added in the resources created>"
org_mail_domain       = "<email domain of the admin>" #example - publicissapient.com
admin_user            = "<username of the admin>"     #example - manojkumar.dasi

# AWS Specific
region = "<AWS region>"
route_53_hosted_zone_id = "<>"
aws_key_id = ""
aws_secret_access_key = ""
aws_account_id = ""
secret_manager_secret_version = ""  # change number everytime
```

Note:

- admin_user and org_mail_domain should be such that "admin_user@org_mail_domain" makes a valid email id of the admin
- github creds should be of the same repository where this code will get hosted
route_53_hosted_zone_id 

Run

Change the secret_manager_secret_version everytime before you run this ./make.sh command

```sh
chmod +x ./make.sh
./make.sh <region> <cluster_name>
```

It will take around 35-40 mins for the complete deployment to be in the place. Once deployment is done, go to "console.`<dns_zone>`" to access the dashboard.

To destroy the resources, run

```sh
chmod +x ./destroy.sh
./destroy.sh 
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



## Debugging application with Force sync to ArgoCD 

```
argocd app sync bodhi-forecast-ui 
argocd app sync bodhi-core
argocd app sync user-onboarding 
argocd app sync istio-operatoxwr
argocd app sync jupyter-web-app
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


Note:  Subnet value in setup.conf should be given in some way. Images should be changed.