# Node Credentials
variable "node-credentials" {
  default = { 
    admin-username = "iamsuperman"
    ssh-keypath = "~/.ssh/id_rsa.pub"
    ssh-keypath-private = "~/.ssh/id_rsa"
  }
}

# Rancher Cluster
variable "rancher-resource-group-name" {
  description = "Resource Group for the Rancher cluster"
}

variable "rancher-region" {
  description = "Region for the Rancher cluster"
}

variable "rancher-etcd-node-count" {
  description = "Number of etcd nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

variable "rancher-controlplane-node-count" {
  description = "Number of controlplane nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

variable "rancher-worker-node-count" {
  description = "Number of worker nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

# Kubernetes Cluster
variable "k8s-resource-group-name" {
  description = "Resource Group for the k8s cluster"
}

variable "k8s-region" {
  description = "Region for the k8s cluster"
}
variable "k8s-etcd-node-count" {
  description = "Number of etcd nodes in the k8s cluster"
  default = 1 
}

variable "k8s-controlplane-node-count" {
  description = "Number of controlplane nodes in the k8s cluster"
  default = 1 
}

variable "k8s-worker-node-count" {
  description = "Number of worker nodes in the k8s cluster"
  default = 1 
}