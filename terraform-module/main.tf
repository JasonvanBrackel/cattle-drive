# Configure the Azure Provider
provider "azurerm" {

}


## Resource Groups 
# Rancher Resource Group
module "rancher-resource-group" {
  source = "./resourcegroup-module"

  group-name = var.rancher-resource-group-name
  region = var.rancher-region
}

# Kubernete Cluster Resource Group
module "k8s-resource-group" {
  source = "./resourcegroup-module"
  
  group-name = var.k8s-resource-group-name
  region = var.k8s-region
}

# Nodes
locals {
   node-definition = {
    admin-username = var.node-credentials.admin-username
    ssh-keypath = var.node-credentials.ssh-keypath
    ssh-keypath-private = var.node-credentials.ssh-keypath-private
    size = "Standard_DS1_v2"
    disk-type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
    docker-version = "18.09"
  }
}

## Networks
module "rancher-network" {
  source = "./network-module"

  resource-group = module.rancher-resource-group.resource-group

}

module "k8s-network" {
  source = "./network-module"

  resource-group = module.k8s-resource-group.resource-group
}


module "rancher-etcd" {
  source = "./node-module"
  prefix = "etcd"

  resource-group = module.rancher-resource-group.resource-group
  node-count = var.rancher-etcd-node-count
  subnet-id = module.rancher-network.subnet-id
  address-starting-index = 0
  node-definition = local.node-definition
}

module "rancher-control" {
  source = "./node-module"
  prefix = "control"

  resource-group = module.rancher-resource-group.resource-group
  node-count = var.rancher-controlplane-node-count
  subnet-id = module.rancher-network.subnet-id
  address-starting-index = var.rancher-etcd-node-count
  node-definition = local.node-definition  
}

module "rancher-worker" {
  source = "./node-module"
  prefix = "worker"

  resource-group = module.rancher-resource-group.resource-group
  node-count = var.rancher-worker-node-count
  subnet-id = module.rancher-network.subnet-id
  address-starting-index = var.rancher-etcd-node-count + var.rancher-controlplane-node-count
  node-definition = local.node-definition
}

resource rke_cluster "rancher-cluster" {
  depends_on = [module.rancher-etcd,module.rancher-control,module.rancher-worker]
  dynamic nodes {
    for_each = module.rancher-etcd.nodes
    content {
      address = module.rancher-etcd.publicIps[nodes.key].ip_address
      internal_address = module.rancher-etcd.privateIps[nodes.key].private_ip_address
      user    = module.rancher-etcd.node-definition.admin-username
      role    = [module.rancher-etcd.prefix]
      ssh_key = file(module.rancher-etcd.node-definition.ssh-keypath-private)
    }
  }

  dynamic nodes {
    for_each = module.rancher-control.nodes
    content {
      address = module.rancher-control.publicIps[nodes.key].ip_address
      internal_address = module.rancher-control.privateIps[nodes.key].private_ip_address
      user    = module.rancher-control.node-definition.admin-username
      role    = ["controlplane"]
      ssh_key = file(module.rancher-control.node-definition.ssh-keypath-private)
    }
  }

  dynamic nodes {
    for_each = module.rancher-worker.nodes
    content {
      address = module.rancher-worker.publicIps[nodes.key].ip_address
      internal_address = module.rancher-worker.privateIps[nodes.key].private_ip_address
      user    = module.rancher-worker.node-definition.admin-username
      role    = [module.rancher-worker.prefix]
      ssh_key = file(module.rancher-worker.node-definition.ssh-keypath-private)
    }
  }

  addons = <<EOL
---
kind: ServiceAccount
apiVersion: v1
metadata:
  name: tiller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: tiller
  namespace: kube-system
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOL
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content = rke_cluster.rancher-cluster.kube_config_yaml
}

module "front-end-lb" {
  source = "./loadbalancer-module"

  resource-group = module.rancher-resource-group.resource-group
  domain-name = var.rancher-domain-name
  backend-nics = module.rancher-worker.privateIps
}

module "cloudflare-dns" {
  source = "./cloudflare-module"
  
  domain-name = var.rancher-domain-name
  cloudflare-email = var.cloudflare-email
  cloudflare-token = var.cloudflare-token
  ip-address = module.front-end-lb.ip-address
}