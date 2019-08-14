#!/bin/bash

# Login to Azure CLI first
# az login

# Variables
resource_group_name="automate-all-the-things"
service_principal_name="TheRanchCast"

# Todo: Create SP to create terraform to create group
# Todo: Create SP using the Azure AD Terrarom Module to create a scoped SP
# Todo: Remove SP scripting from the automate

# Create our AD Group for a Least Privlege Serivce Principal
resource_group=$(az group create -l eastus2 -n $resource_group_name)

# Create the Service Principal scoped to the resource group
service_principal=$(az ad sp create-for-rbac -n $service_principal_name --role contributor --scopes $(echo "$resource_group" | jq .id -r))

# Login to Azure with the Service Principal
az login --service-principal -u $(echo $service_principal | jq .appId -r) -p $(echo $service_principal | jq .password -r) --tenant $(echo $service_principal | jq .tenant -r)

# Set local variables for Terraform
export TF_VAR_subscription_id=$(az account show | jq .id -r)
export TF_VAR_client_id=$(echo $service_principal | jq .appId -r)
export TF_VAR_client_secret=$(echo $service_principal | jq .password -r)
export TF_VAR_tenant_id=$(echo $service_principal | jq .tenant -r)
#TODO fix this automation
export TF_VAR_environment="public"
export TF_VAR_azure_resource_group_name=$(echo $resource_group | jq .name -r)