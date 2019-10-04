output "windows-node-commmand" {
  description = "Command to join the RKE cluster for a windows node"
  value = replace(rancher2_cluster.manager.cluster_registration_token.0.windows_node_command, "--isolation=hyperv", "")
}



output "linux-node-command" {
  description = "Command to join the RKE cluster for a linux node"
  value = rancher2_cluster.manager.cluster_registration_token.0.node_command}
}