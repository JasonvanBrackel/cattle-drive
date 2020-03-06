#!/bin/bash

# Configuration Path from RKE Provider
config_path="$(pwd)/kube_config_cluster.yml"

# Initialize Helm
helm init --kube-context local --kubeconfig "$config_path" --wait