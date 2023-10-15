cd infra
terraform destroy -auto-approve
rm -f output_converted.conf
rm -f output.conf
cd ..
rm -f deployment/configuration/setup.conf
rm -r deployment/test