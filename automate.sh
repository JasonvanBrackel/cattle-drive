#!/bin/bash

# Create our AD Group for a Least Privlege Serivce Principal
resource_group=$(az group create -l eastus2 -n jvb-automate-all-things)

# Create the Service Principal scoped to the resource group

# Login to Azure with the Service Principal
az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID

# Episode 4