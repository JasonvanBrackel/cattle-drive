#!/bin/bash
rm output.json
rm terraform.tfstate*
rm terraform-provider-rke-* -r
rm kube_config_cluster.yml
rm .terraform.tfstate.lock.info

terraform init
terraform apply