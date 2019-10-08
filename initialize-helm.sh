#!/bin/bash

# Configuration Path from RKE Provider
config_path="$(pwd)/kube_config_cluster.yml"

# Initialize Helm
helm init --service-account tiller --kube-context local --kubeconfig "$config_path" --wait