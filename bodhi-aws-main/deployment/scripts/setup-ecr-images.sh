read -p 'Region (for AWS Region): ' REGION
read -p 'Accountid (for AWS accountid): ' AWS_ACCOUNTID
echo $REGION, $AWS_ACCOUNTID

# login to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com


# Pull the images in local repository

# Create Repo, Tag and Push 

# Central Dashboard
aws ecr create-repository --repository-name bodhi-central-dashboard --region $REGION --profile role
docker pull psbodhi/bodhi-central-dashboard:1.0.0
docker tag psbodhi/bodhi-central-dashboard:1.0.0 $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-central-dashboard:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-central-dashboard:1.0.0

# Superset
aws ecr create-repository --repository-name bodhi-superset --region $REGION --profile role
docker pull psbodhi/bodhi-superset:1.0.0
docker tag psbodhi/bodhi-superset:1.0.0 $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-superset:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-superset:1.0.0

# vscode 
aws ecr create-repository --repository-name bodhi-vscode-server --region $REGION --profile role
docker pull psbodhi/bodhi-vscode-server:1.0.0
docker tag psbodhi/bodhi-vscode-server:1.0.0 $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-vscode-server:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-vscode-server:1.0.0

# jupyter notebook 
aws ecr create-repository --repository-name bodhi-notebook-pipeline --region $REGION --profile role
docker pull psbodhi/bodhi-notebook-pipeline:1.0.0
docker tag psbodhi/bodhi-notebook-pipeline:1.0.0 $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-notebook-pipeline:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-notebook-pipeline:1.0.0

# jupyter notebook 
aws ecr create-repository --repository-name bodhi-jupyter-forecast --region $REGION --profile role
docker pull psbodhi/bodhi-jupyter-forecast:1.0.0
docker tag psbodhi/bodhi-jupyter-forecast:1.0.0 $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-jupyter-forecast:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-jupyter-forecast:1.0.0

aws ecr create-repository --repository-name bodhi-jupyter-forecast-ray --region $REGION --profile role
docker pull psbodhi/bodhi-jupyter-forecast-ray:1.0.0
docker tag psbodhi/bodhi-jupyter-forecast-ray:1.0.0  $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-jupyter-forecast-ray:1.0.0
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-jupyter-forecast-ray:1.0.0


aws ecr create-repository --repository-name bodhi-ray --region $REGION --profile role
docker pull psbodhi/ray:1.7.2-cpu-bodhi
docker tag psbodhi/ray:1.7.2-cpu-bodhi  $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-ray:1.7.2-cpu-bodhi
docker push $AWS_ACCOUNTID.dkr.ecr.$REGION.amazonaws.com/bodhi-ray:1.7.2-cpu-bodhi



