#!/bin/bash
rm output.json
rm terraform.tfstate*

terraform init
terraform apply