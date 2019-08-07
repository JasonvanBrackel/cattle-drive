#!/bin/bash

# Variables
resource_group_name="automate-all-things"
service_principal_name="TheRanchCast"

# Create our AD Group for a Least Privlege Serivce Principal
resource_group=$(az group create -l eastus2 -n $resource_group_name)

# Create the Service Principal scoped to the resource group
service_principal=$(az ad sp create-for-rbac -n $service_principal_name --role contributor --scopes $(echo "$resource_group" | jq .id -r))

# Login to Azure with the Service Principal
az login --service-principal -u $(echo $service_principal | jq .appId -r) -p $(echo $service_principal | jq .password -r) --tenant $(echo $service_principal | jq .tenant -r)

# Episode 4