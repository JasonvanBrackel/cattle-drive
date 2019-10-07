#!/bin/bash
rm output.json
rm terraform.tfstate*
rm terraform-provider-rke-* -r
rm kube_config_cluster.yml

terraform init
terraform apply