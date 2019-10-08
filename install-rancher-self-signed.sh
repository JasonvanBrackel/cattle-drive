#!/bin/bash

# Configuration Path from RKE Provider
config_path="$(pwd)/kube_config_cluster.yml"

# Terraform Templates
lets_encrypt_email=${lets-encrypt-email}
lets_encrypt_environment=${lets-encrypt-environment}
rancher_hostname=${rancher-domain-name}

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha

helm repo update

# Install Rancher
helm install rancher-latest/rancher \
  --version v2.3.0 \
  --name rancher \
  --namespace cattle-system \
  --kube-context local \
  --kubeconfig "$config_path" \
  --set hostname="$rancher_hostname" \
  --set auditLog.level="1" \
  --set addLocal="true" \
  --timeout="600" \
  --wait
