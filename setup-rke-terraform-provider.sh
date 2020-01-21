#!/bin/bash

# Download the provider
TERRAFORM_VERSION="0.14.1"
ARCH="linux-amd64"
curl  -L "https://github.com/rancher/terraform-provider-rke/releases/download/$TERRAFORM_VERSION/terraform-provider-rke_$(echo $TERRAFORM_VERSION)_$ARCH.zip" -o terraform_provider_rke.zip

# Unzip
unzip terraform_provider_rke.zip

# Move to the plugins directory
mv "terraform-provider-rke_v$TERRAFORM_VERSION" ~/.terraform.d/plugins/terraform-provider-rke

# Cleanup
rm terraform_provider_rke.zip