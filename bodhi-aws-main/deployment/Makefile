DOMAIN_NAME=mlopsbodhi.xyz
GIT_PROJECT_NAME=enterprise-insights
GIT_REPO_NAME=bodhi-aws-stack-testing
SECRET_MANAGER=bodhi-sc-19
EKS_CLUSTER_NAME=bodhi-stack-prod
REGION_NAME=us-east-2
VPC_NAME=vpc-01b4ae6f5c6989f46
EFS_NAME=fs-0dc13d5aabe60fa39.efs.us-east-2.amazonaws.com
ROUTE53_HOSTZONE_ID=Z06182752KFUQ4YUJNTOB
RDS_HOST_NAME=bodhicoreprodrds.cddmufau5exq.us-east-2.rds.amazonaws.com
EMAIL_DOMAIN=publicissapient.com
USER=akriti-dixit
SUBNET_1=subnet-05bf81aaa157825b8
SUBNET_2=subnet-0dae8331d8210b78d
SUBNET_3=subnet-0685010647d2de4a5
SUPERSET_PASSWORD=bodhipc
FORECAST_UI_EMAIL=akriti-dixit
AWS_SECRET_MANAGER_PATH=bodhi-stack-prod/bodhi-sc-19/prod-repo



OS_NAME=$(shell uname -s | tr A-Z a-z)
#for prompt colors - Green
GR=\033[0;32m
 #for prompt colors - No Color
NC=\033[0m
blue=$(shell tput setaf 6)
red:=$(shell tput setaf 1)
green:=$(shell tput setaf 2)
reset:=$(shell tput sgr0)

$(info $(red) After Putting the parameters)
$(info $(blue)Bodhi platform AWS account ID : $(AWS_ACCOUNT_ID) )
$(info $(blue)Bodhi platform Domain to configure Bodhi app : $(DOMAIN_NAME) )
$(info $(blue)Bodhi platform secret manager middle name which configured in terraform SC_MANAGER : $(SECRET_MANAGER) )
$(info $(blue)Bodhi platform eks cluster name from terraform output state : $(EKS_CLUSTER_NAME) )
$(info $(blue)Bodhi platform AWS region name : $(REGION_NAME) )
$(info $(blue)Bodhi platform AWS VPC Name : $(VPC_NAME) )
$(info $(blue)Bodhi platform AWS EFS storage name from terraform output state : $(EFS_NAME) )
$(info $(blue)Bodhi platform AWS Route53 domain Host zone ID : $(ROUTE53_HOSTZONE_ID) )
$(info $(blue)Bodhi platform Git Repo where you pushed the Bodhi Core : $(GIT_REPO_NAME) )
$(info $(blue)Bodhi platform Github Project Name : $(GIT_PROJECT_NAME) )
$(info $(blue)Bodhi platform AWS RDS name from the Terraform Output state example(bodhicoreprodrds.c3edw.eu-west-1.rds.amazonaws.com): $(RDS_HOST_NAME) )
$(info $(blue)Bodhi platform Username with format(<FIRSTNAME>.<LASTNAME>) example: rahul.roy : $(USER) )
$(info $(blue)Bodhi platform Domain od email for the organization(eg: publicissapient.com ) : $(EMAIL_DOMAIN) )
$(info $(blue)Bodhi platform AWS Subnet 1 : $(SUBNET_1) )
$(info $(blue)Bodhi platform AWS Subnet 2 : $(SUBNET_2) )
$(info $(blue)Bodhi platform AWS Subnet 3 : $(SUBNET_3) )
$(info $(blue)Bodhi platform Superset Passowrd : $(SUPERSET_PASSWORD) )
$(info $(blue)Bodhi platform Forecast the username with format(<FIRSTNAME>.<LASTNAME>) example: rahul.roy): $(FORECAST_UI_EMAIL) )




DISTRIBUTION=distribution
# Perform a simple recursive find-and-replace on all variables defined in setup.conf
SETUP_CONF_PATH=configuration/setup-config.conf # location of the setup config
DISTRIBUTION_PATH=./${DISTRIBUTION} # folder where the distribution's YAML files are to be found
$(info $(red)Bodhi DISTRIBUTION : $(DISTRIBUTION) )




ifeq ($(OS_NAME), darwin)
	# KUSTOMIZE_BINARY
	KUSTOMIZE_BINARY=https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_darwin_amd64
	# SED string 
	sed_str=''
endif

### Linux (including Google Cloud Shell)
ifeq ($(OS_NAME), linux)
	# KUSTOMIZE_BINARY
	KUSTOMIZE_BINARY=https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
	# SED string 
	sed_str=
endif

one-click-deploy:  set-deployment-parameters set-repo-access connect-cluster  run-configuration-parameters  deploy-argocd  git-push application-deploy
	$(info $(green)Wait for 20 mins to deploy )
	$(info $(green)Bodhi platform has been successfully configured on AWS )
	$(info $(green)Access the Bodhi Administrator using the link : https://auth.$(DOMAIN_NAME))
	$(info $(green)Access the Bodhi platform using the link : https://console.$(DOMAIN_NAME))

one-click-test: set-repo-access-test  
	echo "Done"
set-repo-access-test: 
	echo  user name is ${HTTPS_USERNAME}

one-click-destroy: destroy-loadbalancer 
	set -e ;\
	aws s3 rb s3://$(EKS_CLUSTER_NAME)-pipelines --force 

check-version: 
	set -e ;\
	kustomize version && \
	terraform version && \
	kubectl version && \
	argocd version 

setup-core-bodhi: 

	# setup Kustomize	
	# Dependencies : curl, Kustomize 
	set -e ;\
	wget ${KUSTOMIZE_BINARY} -O kustomize; \
	chmod +x kustomize; \
	kustomize version;
push-one:
	aws ecr create-repository --repository-name bodhi-superset --region $(REGION_NAME) 
	docker pull psbodhi/bodhi-superset:1.0.0
	docker tag psbodhi/bodhi-superset:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-superset:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-superset:1.0.0



push-image-ecr :
	aws ecr get-login-password --region ${REGION_NAME}  | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION_NAME}.amazonaws.com
	# Central Dashboard
	aws ecr create-repository --repository-name bodhi-central-dashboard --region $(REGION_NAME) 
	docker pull psbodhi/bodhi-central-dashboard:1.0.0
	docker tag psbodhi/bodhi-central-dashboard:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-central-dashboard:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-central-dashboard:1.0.0

	# Superset
	aws ecr create-repository --repository-name bodhi-superset --region $(REGION_NAME)
	docker pull psbodhi/superset:1.0.0
	docker tag psbodhi/superset:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-superset:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-superset:1.0.0

	# vscode 
	aws ecr create-repository --repository-name bodhi-vscode-server --region $(REGION_NAME) 
	docker pull psbodhi/bodhi-vscode-server:1.0.0
	docker tag psbodhi/bodhi-vscode-server:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-vscode-server:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-vscode-server:1.0.0

	# jupyter notebook 
	aws ecr create-repository --repository-name bodhi-notebook-pipeline --region $(REGION_NAME) 
	docker pull psbodhi/bodhi-notebook-pipeline:1.0.0
	docker tag psbodhi/bodhi-notebook-pipeline:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-notebook-pipeline:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-notebook-pipeline:1.0.0

	# jupyter notebook 
	aws ecr create-repository --repository-name bodhi-jupyter-forecast --region $(REGION_NAME) 
	docker pull psbodhi/bodhi-jupyter-forecast:1.0.0
	docker tag psbodhi/bodhi-jupyter-forecast:1.0.0 $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-jupyter-forecast:1.0.0
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION_NAME).amazonaws.com/bodhi-jupyter-forecast:1.0.0

	#ray
	aws ecr create-repository --repository-name bodhi-ray --region ${REGION} 
	docker pull psbodhi/ray:1.7.2-cpu-bodhi
	docker tag psbodhi/ray:1.7.2-cpu-bodhi  ${AWS_ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/bodhi-ray:1.7.2-cpu-bodhi
	docker push ${AWS_ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/bodhi-ray:1.7.2-cpu-bodhi



set-repo-access :
	aws secretsmanager put-secret-value --region $(REGION_NAME) --secret-id $(AWS_SECRET_MANAGER_PATH) --secret-string '{"HTTPS_USERNAME":'"\"$(HTTPS_USERNAME)\""',"HTTPS_PASSWORD":'"\"$(HTTPS_PASSWORD)\""'}' #--profile role

connect-cluster :
	aws eks   update-kubeconfig --name ${EKS_CLUSTER_NAME}  --region ${REGION_NAME}


restart-awsnode-rollout :
	set -e ;\
	kubectl get nodes && \
	kubectl annotate serviceaccount -n kube-system aws-node eks.amazonaws.com/role-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:role/${EKS_CLUSTER_NAME}-eks-cni && \
	kubectl rollout restart -n kube-system ds/aws-node && \
	sleep 60


set-deployment-parameters :
	set -e ;\
	cp -r setup-root.conf setup-config.conf && \
	sed -i '' -e 's/%AWS_ACCOUNT_ID/'"${AWS_ACCOUNT_ID}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%DOMAIN_NAME/'"${DOMAIN_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%DOMAIN_SHORT_NAME/'"${DOMAIN_SHORT_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%SECRET_MANAGER/'"${SECRET_MANAGER}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%EKS_CLUSTER_NAME/'"${EKS_CLUSTER_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%REGION_NAME/'"${REGION_NAME}"'/g;' ./setup-config.conf  && \
	sed -i '' -e 's/%VPC_NAME/'"${VPC_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%EFS_NAME/'"${EFS_NAME}"'/g;' ./setup-config.conf && \
 	sed -i '' -e 's/%ROUTE53_HOSTZONE_ID/'"${ROUTE53_HOSTZONE_ID}"'/g;' ./setup-config.conf 
	sed -i '' -e 's/%GIT_REPO_NAME/'"${GIT_REPO_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%GIT_PROJECT_NAME/'"${GIT_PROJECT_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%RDS_HOST_NAME/'"${RDS_HOST_NAME}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%EMAIL_DOMAIN/'"${EMAIL_DOMAIN}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%USER/'"${USER}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%SUBNET_1/'"${SUBNET_1}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%SUBNET_2/'"${SUBNET_2}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%SUBNET_3/'"${SUBNET_3}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%SUPERSET_PASSWORD/'"${SUPERSET_PASSWORD}"'/g;' ./setup-config.conf && \
	sed -i '' -e 's/%FORECAST_UI_EMAIL/'"${FORECAST_UI_EMAIL}"'/g;' ./setup-config.conf && \
	cp -r setup-config.conf configuration/setup-config.conf && \
	rm -rf setup-config.conf



run-configuration-parameters: clean-distribution # make repo-sync setup-config-path=configuration/setup.conf 
	@while read -r file; do \
		PLACEHOLDER=$$(echo "$$file" | cut -d'=' -f1); \
		VALUE=$$(echo "$$file" | cut -d'=' -f2); \
		echo $$PLACEHOLDER : $$VALUE; \
		grep -rli $$PLACEHOLDER ${DISTRIBUTION}/* | xargs -I@ sed -i '' "s~$$PLACEHOLDER~$$VALUE~g" @ ;\
    done <$(SETUP_CONF_PATH)

clean-distribution:
	rm -rf ${DISTRIBUTION} ;  \
	cp -r distribution-template ${DISTRIBUTION};  


deploy-argocd :
	set -e ; \
	kustomize build distribution/argocd/base | kubectl apply -f - && \
	sleep 30  && \
	kustomize build distribution/external-secrets | kubectl apply -f - && \
	sleep 30 && \
	kustomize build distribution/argocd/overlays/private-repo | kubectl apply -f - && \
	sleep 30

git-push :
	git add .
	git commit -m "Bodhi Deployment Stack"
	git push

application-deploy :
	kubectl apply -f distribution/bodhi-core.yaml

launch-argo-dashboard :
	set -e ;\ 
	ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) && \
	echo ${ARGOCD_PASSWORD} && \
	kubectl port-forward svc/argocd-server -n argocd 8080:443 && \
	argocd login localhost:8080 --insecure --username admin --password $ARGOCD_PASSWORD



destroy-loadbalancer : 
	set -e ; \
	kubectl patch service -n istio-system istio-ingressgateway -p '{"spec": {"type": "NodePort"}}' && \
	LOAD_BALANCER_ARN=$$(aws elbv2 describe-load-balancers --name $(EKS_CLUSTER_NAME)-nlb --region $(REGION_NAME) --output text --query 'LoadBalancers[0].LoadBalancerArn') && \
	echo $$LOAD_BALANCER_ARN && \
	TARGET_GROUPS=$$(aws elbv2 describe-target-groups --region $(REGION_NAME) --output text --load-balancer-arn $$LOAD_BALANCER_ARN --query 'TargetGroups[].TargetGroupArn') && \
	echo $$TARGET_GROUPS && \
	aws elbv2 delete-load-balancer --load-balancer-arn $$LOAD_BALANCER_ARN  --region $(REGION_NAME)  && \
	for TARGET_GROUP in $$TARGET_GROUPS ; do \
		aws elbv2 delete-target-group --region $(REGION_NAME) --target-group-arn $$TARGET_GROUP ; \
	done ; \



set-user : run-configuration-parameters git-push 
	echo "Set the User"

user-onboarding :
	set -e ; \
	echo ${FIRSTNAME_LASTNAME} , ${EMAIL_ID} && \
	cp -r ./scripts/firstname-lastname.yaml ./${FIRSTNAME_LASTNAME}.yaml && \
	sed -i '' -e 's/%FIRSTNAME_LASTNAME/'"${FIRSTNAME_LASTNAME}"'/g;' ./${FIRSTNAME_LASTNAME}.yaml && \
	sed -i '' -e 's/%EMAIL_ID/'"${EMAIL_ID}"'/g;' ./${FIRSTNAME_LASTNAME}.yaml && \
	cp -r  ./${FIRSTNAME_LASTNAME}.yaml ./distribution-template/user-onboarding/profiles/${FIRSTNAME_LASTNAME}.yaml && \
	rm -rf ${FIRSTNAME_LASTNAME}.yaml && \
	echo "User onboarded ${FIRSTNAME_LASTNAME} with ${EMAIL_ID}" && \
	echo "  - profiles/${FIRSTNAME_LASTNAME}.yaml" >> ./distribution-template/user-onboarding/kustomization.yaml && \
	make run-configuration-parameters && \
	make user-operation-git-push FIRSTNAME_LASTNAME=onboard-user-${FIRSTNAME_LASTNAME}



user-offboard :
	set -e ; \
	sed '/${FIRSTNAME_LASTNAME}/d' ./distribution-template/user-onboarding/kustomization.yaml  > ./distribution-template/user-onboarding/kustomization.txt && \
	mv ./distribution-template/user-onboarding/kustomization.txt ./distribution-template/user-onboarding/kustomization.yaml && \
	rm -rf ./distribution-template/user-onboarding/profiles/${FIRSTNAME_LASTNAME}.yaml && \
	make run-configuration-parameters && \
	make user-operation-git-push FIRSTNAME_LASTNAME=offboard-user-${FIRSTNAME_LASTNAME}

user-operation-git-push :
	git add .
	git commit -m "${FIRSTNAME_LASTNAME}"
	git push


credentials-application :
	set -e ; \
	KEYCLOAK_PASSWORD=$$(kubectl -n auth get secret keycloak-secret -o jsonpath="{.data.admin-password}" | base64 -d) && \
	ARGOCD_PASSWORD=$$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)  && \
	GRAFANA_PASSWORD=$$(kubectl -n monitoring get secret grafana-admin-secret  -o jsonpath="{.data.admin-password}" | base64 -d) && \
	GRAFANA_USERNAME=$$(kubectl -n monitoring get secret grafana-admin-secret  -o jsonpath="{.data.admin-user}" | base64 -d) && \
	echo "Key cloak password is : $$KEYCLOAK_PASSWORD and username : admin" && \
	echo "ArgoCD  password is : $$ARGOCD_PASSWORD" && \
	echo "Grafana username is :$$GRAFANA_USERNAME and password is : $$GRAFANA_PASSWORD" && \
	echo "Superset username is : admin and password is : ${SUPERSET_PASSWORD}"
	$(info $(green) Successfully retreived the credentials from Bodhi Platform.)


connect-argo-local :
	set -e ; \
	ARGOCD_PASSWORD=$$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)  && \
	echo "ArgoCD  password is : $$ARGOCD_PASSWORD" && \
	argocd login localhost:8080 --insecure --username admin --password $$ARGOCD_PASSWORD && \
	argocd app sync user-onboarding

argo-portforward :
		kubectl port-forward svc/argocd-server -n argocd 8080:443 

