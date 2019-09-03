#!/bin/bash

# Login to Azure CLI first
az login --use-device-code

# Init Terraform
terraform init

# TODO: Check our path

# Variables
resource_group_name="automate-all-the-things"
export service_principal_name="TheRanchCast"

# Todo: Create SP to create terraform to create group
# Todo: Create SP using the Azure AD Terrarom Module to create a scoped SP
# Todo: Remove SP scripting from the automate

# Create our AD Group for a Least Privlege Serivce Principal
# resource_group=$(az group create -l eastus2 -n $resource_group_name)

# Create the Service Principal scoped to the resource group
service_principal=$(az ad sp create-for-rbac -n $service_principal_name --role contributor)

sleep 10

# Login to Azure with the Service Principal
az login --service-principal -u $(echo $service_principal | jq .appId -r) -p $(echo $service_principal | jq .password -r) --tenant $(echo $service_principal | jq .tenant -r)

# Set local variables for Terraform
export TF_VAR_subscription_id=$(az account show | jq .id -r)
export TF_VAR_client_id=$(echo $service_principal | jq .appId -r)
export TF_VAR_client_secret=$(echo $service_principal | jq .password -r)
export TF_VAR_tenant_id=$(echo $service_principal | jq .tenant -r)
#TODO fix this automation so we grab the enviornment dynamically.
export TF_VAR_environment="public"
#TODO Create our Service Principal and Resource Group from Code and Dynamically populate (Least Privlege)
export TF_VAR_azure_resource_group_name=$resource_group_name 
export TF_VAR_azure_region=eastus2
#export TF_VAR_azure_resource_group_name=$(echo $resource_group | jq .name -r)

# Run Terraform 
terraform apply -auto-approve

# TODO: DO something fun with the output