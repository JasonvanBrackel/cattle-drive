#!/bin/bash

# Configuration Path from RKE Provider
config_path="$(pwd)/kube_config_cluster.yml"

# Terraform Templates
lets_encrypt_email=${lets-encrypt-email}
lets_encrypt_environment=${lets-encrypt-environment}
rancher_hostname=${rancher-domain-name}

# Initialize Helm
helm init --service-account tiller --kube-context local --kubeconfig "$config_path" --wait

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install Cert Manager
kubectl --kubeconfig="$config_path" apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.9/deploy/manifests/00-crds.yaml
kubectl --kubeconfig="$config_path" create namespace cert-manager
kubectl --kubeconfig="$config_path" label namespace cert-manager certmanager.k8s.io/disable-validation=true

helm install \
  --name cert-manager \
  --namespace cert-manager \
  --kube-context local \
  --kubeconfig "$config_path" \
  --version v0.9.1 \
  --wait \
  jetstack/cert-manager

# Install Rancher
helm install rancher-alpha/rancher \
  --version v2.3.0-alpha7 \
  --name rancher \
  --namespace cattle-system \
  --kube-context local \
  --kubeconfig "$config_path" \
  --set ingress.tls.source="rancher" \
  --set hostname="$rancher_hostname" \
  --set auditLog.level="1" \
  --set addLocal="true" \
  --wait
