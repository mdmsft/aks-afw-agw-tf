variable "resource_suffix" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = string
}

variable "context_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "kubernetes_cluster_orchestrator_version" {
  type     = string
  nullable = true
}

variable "kubernetes_cluster_sku_tier" {
  type = string
}

variable "kubernetes_cluster_automatic_channel_upgrade" {
  type = string
}

variable "kubernetes_cluster_azure_policy_enabled" {
  type = bool
}

variable "kubernetes_cluster_service_cidr" {
  type = string
}

variable "kubernetes_cluster_docker_bridge_cidr" {
  type = string
}

variable "kubernetes_cluster_default_node_pool_vm_size" {
  type = string
}

variable "kubernetes_cluster_default_node_pool_max_pods" {
  type = number
}

variable "kubernetes_cluster_default_node_pool_min_count" {
  type = number
}

variable "kubernetes_cluster_default_node_pool_max_count" {
  type = number
}

variable "kubernetes_cluster_default_node_pool_os_disk_size_gb" {
  type = number
}

variable "kubernetes_cluster_default_node_pool_os_sku" {
  type = string
}

variable "kubernetes_cluster_default_node_pool_max_surge" {
  type = string
}

variable "kubernetes_cluster_default_node_pool_availability_zones" {
  type = list(string)
}

variable "kubernetes_cluster_default_node_pool_orchestrator_version" {
  type     = string
  nullable = true
}

variable "kubernetes_cluster_workload_node_pool_vm_size" {
  type = string
}

variable "kubernetes_cluster_workload_node_pool_max_pods" {
  type = number
}

variable "kubernetes_cluster_workload_node_pool_min_count" {
  type = number
}

variable "kubernetes_cluster_workload_node_pool_max_count" {
  type = number
}

variable "kubernetes_cluster_workload_node_pool_os_disk_size_gb" {
  type = number
}

variable "kubernetes_cluster_workload_node_pool_os_sku" {
  type = string
}

variable "kubernetes_cluster_workload_node_pool_max_surge" {
  type = string
}

variable "kubernetes_cluster_workload_node_pool_availability_zones" {
  type = list(string)
}

variable "kubernetes_cluster_workload_node_pool_orchestrator_version" {
  type     = string
  nullable = true
}

variable "kubernetes_cluster_workload_node_pool_labels" {
  type = map(string)
}

variable "kubernetes_cluster_workload_node_pool_taints" {
  type = list(string)
}

variable "kubernetes_cluster_network_plugin" {
  type = string
}

variable "kubernetes_cluster_network_policy" {
  type = string
}

variable "kubernetes_cluster_open_service_mesh_enabled" {
  type = bool
}

variable "kubernetes_cluster_microsoft_defender_enabled" {
  type = bool
}

variable "kubernetes_cluster_key_vault_secrets_provider_enabled" {
  type = bool
}

variable "kubernetes_cluster_oidc_issuer_enabled" {
  type = bool
}

variable "kubernetes_cluster_workload_identity_enabled" {
  type = bool
}

variable "kubernetes_service_cluster_administrators" {
  type = list(string)
}

variable "kubernetes_service_cluster_users" {
  type = list(string)
}

variable "kubernetes_service_rbac_administrators" {
  type = list(string)
}

variable "kubernetes_service_rbac_cluster_administrators" {
  type = list(string)
}

variable "kubernetes_service_rbac_readers" {
  type = list(string)
}

variable "kubernetes_service_rbac_writers" {
  type = list(string)
}

variable "firewall_private_ip_address" {
  type = string
}

variable "firewall_public_ip_address" {
  type = string
}

variable "container_registry_id" {
  type = string
}
