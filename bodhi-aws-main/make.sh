git pull
cd infra
terraform init 
terraform apply -auto-approve
terraform output > output.conf
cd ..
mkdir deployment/test
chmod +x generators/setup-generator.sh
generators/setup-generator.sh
chmod +x generators/deploy-generator.sh
generators/deploy-generator.sh
# chmod +x generators/docker-images-push-generator.sh
# generators/docker-images-push-generator.sh
cd deployment
chmod +x ./scripts/setup-repo-mac.sh  
./scripts/setup-repo-mac.sh configuration/setup.conf
cd ..
git add .
git status
git commit -m "changes done by run"
git push

aws eks --region $1 update-kubeconfig --name $2 
# kubectl create namespace gpu-resources
# kubectl apply -f nvidia-device-plugin-ds.yaml  

cd deployment
chmod +x test/deploy.sh
test/deploy.sh
# chmod +x test/deploy-docker-images.sh
# test/deploy-docker-images.sh
cd ..

