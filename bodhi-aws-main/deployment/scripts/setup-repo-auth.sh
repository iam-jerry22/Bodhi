read -p 'Username (for Bodhi Core Repo Access): ' HTTPS_USERNAME
read -p 'Password (for Bodhi Core Repo Access): ' HTTPS_PASSWORD
read -p 'Region (for Bodhi region): ' REGION
read -p 'AWS Secret Manager Path (Look for bodhi_repo_secret_manager_name in Terraform Output): ' AWS_SECRET_MANAGER_PATH


echo $HTTPS_USERNAME, $HTTPS_PASSWORD, $AWS_SECRET_MANAGER_PATH,$REGION
aws secretsmanager put-secret-value --region $REGION --secret-id $AWS_SECRET_MANAGER_PATH --secret-string '{"HTTPS_USERNAME":'"\"$HTTPS_USERNAME\""',"HTTPS_PASSWORD":'"\"$HTTPS_PASSWORD\""'}' #--profile role

