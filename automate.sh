#!/bin/bash

# Create our AD Group for a Least Privlege Serivce Principal
resource_group=$(az group create -l eastus2 -n jvb-automate-all-things)

# Create the Service Principal scoped to the resource group
service_principal=$(az ad sp create-for-rbac -n "TheRanchCast" --role contributor --scopes $(echo "$resource_group" | jq .id -r))

# Login to Azure with the Service Principal
az login --service-principal -u $(echo $service_principal | jq .appId -r) -p $(echo $service_principal | jq .password -r) --tenant $(echo $service_principal | jq .tenant -r)

# Episode 4