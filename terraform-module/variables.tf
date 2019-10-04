# Let's Encrypt
variable "lets-encrypt-email" {
  description = "E-mail address for the let's encrypt account."
  type = string

}

variable "lets-encrypt-environment" {
  description = "Environment (staging, production for let's encrypt)"
  type = string
  default = "staging"
}

# Cloudflare
variable "cloudflare-email" {
  description = "Email Addres for Cloudflare"
  type = string
}

variable "cloudflare-token" {
  description = "Authentication token for Cloudflare"
}


# Node Credentials
variable "node-credentials" {
  description = ""
  type = object({admin-username=string,ssh-keypath=string,ssh-keypath-private=string})
  default = { 
    admin-username = "iamsuperman"
    ssh-keypath = "~/.ssh/id_rsa.pub"
    ssh-keypath-private = "~/.ssh/id_rsa"
  }
}

# Rancher Cluster
variable "rancher-domain-name" {
  type = string
  description = "Domain name for the Rancher cluster"
}

variable "rancher-resource-group-name" {
  type = string
  description = "Resource Group for the Rancher cluster"
  default = "cattle-drive-rancher"
}

variable "rancher-region" {
  type = string
  description = "Region for the Rancher cluster"
  default = "eastus2"
}

variable "rancher-etcd-node-count" {
  type = number
  description = "Number of etcd nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

variable "rancher-controlplane-node-count" {
  type = number
  description = "Number of controlplane nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

variable "rancher-worker-node-count" {
  type = number
  description = "Number of worker nodes in the RKE Cluster for Rancher HA"
  default = 1 
}

# Kubernetes Cluster
variable "k8s-resource-group-name" {
  type = string
  description = "Resource Group for the k8s cluster"
  default = "cattle-drive-k8s"
}

variable "k8s-region" {
  type = string
  description = "Region for the k8s cluster"
  default = "eastus"
}
variable "k8s-etcd-node-count" {
  type = number
  description = "Number of etcd nodes in the k8s cluster"
  default = 1 
}

variable "k8s-controlplane-node-count" {
  type = number
  description = "Number of controlplane nodes in the k8s cluster"
  default = 1 
}

variable "k8s-worker-node-count" {
  type = number
  description = "Number of worker nodes in the k8s cluster"
  default = 1 
}