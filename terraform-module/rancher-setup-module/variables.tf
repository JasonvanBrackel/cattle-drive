variable "kubeconfig-path" {
  description = "Path to the kubeconfig file to autenticate against the Kubernetes cluster"
}

variable "lets-encrypt-email" {
  description = "Email addres for lets encrypt"
}

variable "lets-encrypt-environment" {
  description = "Which lets encrypt environment staging/production"
}

variable "rancher-hostname" {
  description = "Hostname for the rancher server."  
}