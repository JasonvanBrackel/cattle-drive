#!/bin/bash

terraform destroy   -var rancher-resource-group-name="cattle-drive-rancher" \
                    -var rancher-region="eastus" \
                    -var k8s-resource-group-name="cattle-drive-k8s" \
                    -var k8s-region="eastus2" --auto-approve

az ad sp delete --id "http://k8s-sp" 

az ad sp delete --id "http://rancher-sp" 

az ad sp delete --id "http://$service_principal_name"