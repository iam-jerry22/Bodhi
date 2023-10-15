cp -r setup-root.conf setup-config.conf


read -p 'AWS_ACCOUNT_ID (Provide AWS account ID): ' AWS_ACCOUNT_ID
read -p 'DOMAIN_NAME (Provide the Domain to configure Bodhi app): ' DOMAIN_NAME
read -p 'SECRET_MANAGER (Provide the secret manager middle name which configured in terraform SC_MANAGER): ' SECRET_MANAGER
read -p 'EKS_CLUSTER_NAME (Provide the eks cluster name from terraform output state): ' EKS_CLUSTER_NAME
read -p 'REGION_NAME (Provide the region name): ' REGION_NAME
read -p 'VPC_NAME (Provide the VPC Name): ' VPC_NAME
read -p 'EFS_NAME (Provide the EFS storage name from terraform output state): ' EFS_NAME
read -p 'ROUTE53_HOSTZONE_ID (Provide the Route53 domain Host zone ID): ' ROUTE53_HOSTZONE_ID
read -p 'GIT_REPO_NAME (Provide the Github Repo where you pushed the Bodhi Core): ' GIT_REPO_NAME
read -p 'GIT_PROJECT_NAME (Provide the Github Project Name): ' GIT_PROJECT_NAME
read -p 'RDS_HOST_NAME (Provide the RDS name from the Terraform Output state example(bodhicoreprodrds.c3edw.eu-west-1.rds.amazonaws.com)): ' RDS_HOST_NAME
read -p 'EMAIL_DOMAIN (Provide the Domain od email for the organization(eg: publicissapient.com )): ' EMAIL_DOMAIN
read -p 'USER (Provide the username with format(<FIRSTNAME>.<LASTNAME>) example: rahul.roy): ' USER
read -p 'SUBNET_1 (Provide the Public Subnet 1): ' SUBNET_1
read -p 'SUBNET_2 (Provide the Public Subnet 2): ' SUBNET_2
read -p 'SUBNET_3 (Provide the Public Subnet 3): ' SUBNET_3
read -p 'SUPERSET_PASSWORD (Provide the Superset Passowrd): ' SUPERSET_PASSWORD
read -p 'FORECAST_UI_EMAIL (Provide the Forecast the username with format(<FIRSTNAME>.<LASTNAME>) example: rahul.roy): ' FORECAST_UI_EMAIL


echo $AWS_ACCOUNT_ID, $DOMAIN_NAME, $GITHUB_PROJECT_NAME,$REPOSITORY_NAME,$SECRET_MANAGER,$EKS_CLUSTER_NAME, $REGION_NAME, $VPC_NAME,$EFS_NAME, $ROUTE53_HOSTZONE_ID, $GITHUB_REPO_NAME,$RDS_HOST_NAME, $EMAIL_DOMAIN, $USER,$SUBNET_1,$SUBNET_2,$SUBNET_3
sed -i '' -e 's/%AWS_ACCOUNT_ID/'"$AWS_ACCOUNT_ID"'/g;' ./setup-config.conf 
sed -i '' -e 's/%DOMAIN_NAME/'"$DOMAIN_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%SECRET_MANAGER/'"$SECRET_MANAGER"'/g;' ./setup-config.conf 
sed -i '' -e 's/%EKS_CLUSTER_NAME/'"$EKS_CLUSTER_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%REGION_NAME/'"$REGION_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%VPC_NAME/'"$VPC_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%EFS_NAME/'"$EFS_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%ROUTE53_HOSTZONE_ID/'"$ROUTE53_HOSTZONE_ID"'/g;' ./setup-config.conf 
sed -i '' -e 's/%GIT_REPO_NAME/'"$GIT_REPO_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%GIT_PROJECT_NAME/'"$GIT_PROJECT_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%RDS_HOST_NAME/'"$RDS_HOST_NAME"'/g;' ./setup-config.conf 
sed -i '' -e 's/%EMAIL_DOMAIN/'"$EMAIL_DOMAIN"'/g;' ./setup-config.conf 
sed -i '' -e 's/%USER/'"$USER"'/g;' ./setup-config.conf 
sed -i '' -e 's/%SUBNET_1/'"$SUBNET_1"'/g;' ./setup-config.conf 
sed -i '' -e 's/%SUBNET_2/'"$SUBNET_2"'/g;' ./setup-config.conf 
sed -i '' -e 's/%SUBNET_3/'"$SUBNET_3"'/g;' ./setup-config.conf 
sed -i '' -e 's/%SUPERSET_PASSWORD/'"$SUPERSET_PASSWORD"'/g;' ./setup-config.conf 
sed -i '' -e 's/%FORECAST_UI_EMAIL/'"$FORECAST_UI_EMAIL"'/g;' ./setup-config.conf 


cp -r setup-config.conf configuration/setup-config.conf
rm -rf setup-config.conf
