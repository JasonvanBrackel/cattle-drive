variable "public-Ips" {
  description = "Public IP Addresses for the nodes" 
}

variable "private-Ips" {
  description = "Private IP Addresses for the nodes"
}

variable "nodes" {
  description = "Nodes to Join Rancher"
}

variable "node-count" {
  description = "Count of nodes we're adding to Rancher"
}

variable "resource-group" {
  description = "Azure Resource group the nodes belong to "
}

variable "join-command" {
  description = "Rancher Cluster Join Command to be executed"
}

