#!/bin/bash

config_path="$(pwd)/kube_config_cluster.yml"


# Run Terraform  
terraform apply -var rancher-resource-group-name="cattle-drive-rancher" \
                -var rancher-region="eastus" \
                -var k8s-resource-group-name="cattle-drive-k8s" \
                -var k8s-region="eastus2"

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
  --set letsEncrypt.email="$email" \
  --set letsEncrypt.environment="$environment" \
  --set hostname="$rancher_hostname" \
  --set auditLog.level="1" \
  --set addLocal="true" \
  --wait
