#!/bin/bash

config_path="$(pwd)/kube_config_cluster.yml"


# Run Terraform  
terraform apply
terraform output -json >> output.json

$lets_encrypt_email =$(cat output.json | jq -r '.lets-encrypt-environment')
$lets_encrypt_environment = $(cat output.json | jq -r '.lets-encrypt-environment')
$rancher_hostname = $(cat output.json | jq -r '.rancher-domain-name') 

# Initialize Helm
helm init --service-account tiller --kube-context local --kubeconfig "$config_path" --wait

# Install Cert Manager
kubectl --kubeconfig="$config_path" apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.9/deploy/manifests/00-crds.yaml
kubectl --kubeconfig="$config_path" create namespace cert-manager
kubectl --kubeconfig="$config_path" label namespace cert-manager certmanager.k8s.io/disable-validation=true

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  --name cert-manager \
  --namespace cert-manager \
  --kube-context local \
  --kubeconfig "$config_path" \
  --version v0.9.1 \
  --wait \
  jetstack/cert-manager

# Install Rancher
helm install rancher-stable/rancher \
  --version v2.2.8 \
  --name rancher \
  --namespace cattle-system \
  --kube-context local \
  --kubeconfig "$config_path" \
  --set ingress.tls.source="letsEncrypt" \
  --set letsEncrypt.email="$lets_encrypt_email" \
  --set letsEncrypt.environment="$lets_encrypt_environment" \
  --set hostname="$rancher_hostname" \
  --set auditLog.level="1" \
  --set addLocal="true" \
  --wait
