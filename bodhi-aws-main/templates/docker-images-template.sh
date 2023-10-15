docker login _acr_name.azurecr.io -u _acr_name -p _acr_admin_password

echo "uploading mlflow image"
docker load -i ../docker-images/mlflow-azure.tar
# docker load -i ../docker-images/bodhi-forecast-kubeflow.tar
# docker load -i ../docker-images/bodhi-forecast-ui.tar
# docker load -i ../docker-images/elyra-images.tar

docker tag bodhi.azurecr.io/mlflow-azure:1.0.0 _acr_name.azurecr.io/mlflow-azure:1.0.0
# docker tag bodhi.azurecr.io/bodhi-forecast:kubeflow-image _acr_name.azurecr.io/bodhi-forecast:kubeflow-image
# docker tag bodhi.azurecr.io/bodhi-forecast:ui-image-latest _acr_name.azurecr.io/bodhi-forecast:ui-image-latest
# docker tag bodhi.azurecr.io/elyra-images:elyra-v3.10.1-python-3.9.13-test _acr_name.azurecr.io/elyra-images:elyra-v3.10.1-python-3.9.13-test

docker push _acr_name.azurecr.io/mlflow-azure:1.0.0
# docker push _acr_name.azurecr.io/bodhi-forecast:kubeflow-image
# docker push _acr_name.azurecr.io/bodhi-forecast:ui-image-latest
# docker push _acr_name.azurecr.io/elyra-images:elyra-v3.10.1-python-3.9.13-test
