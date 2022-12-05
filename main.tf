module "hub" {
  source                                    = "./modules/hub"
  resource_suffix                           = local.resource_suffix
  location                                  = var.location
  address_space                             = var.hub_address_space
  nat_gateway_public_ip_prefix_length       = var.nat_gateway_public_ip_prefix_length
  log_analytics_workspace_daily_quota_gb    = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  container_registry_sku                    = var.container_registry_sku
}

module "spoke" {
  source                                                     = "./modules/spoke"
  resource_suffix                                            = local.resource_suffix
  location                                                   = var.location
  address_space                                              = var.spoke_address_space
  context_name                                               = local.context_name
  log_analytics_workspace_id                                 = module.hub.log_analytics_workspace_id
  kubernetes_cluster_orchestrator_version                    = var.kubernetes_cluster_orchestrator_version
  kubernetes_cluster_sku_tier                                = var.kubernetes_cluster_sku_tier
  kubernetes_cluster_automatic_channel_upgrade               = var.kubernetes_cluster_automatic_channel_upgrade
  kubernetes_cluster_azure_policy_enabled                    = var.kubernetes_cluster_azure_policy_enabled
  kubernetes_cluster_service_cidr                            = var.kubernetes_cluster_service_cidr
  kubernetes_cluster_docker_bridge_cidr                      = var.kubernetes_cluster_docker_bridge_cidr
  kubernetes_cluster_default_node_pool_vm_size               = var.kubernetes_cluster_default_node_pool_vm_size
  kubernetes_cluster_default_node_pool_max_pods              = var.kubernetes_cluster_default_node_pool_max_pods
  kubernetes_cluster_default_node_pool_min_count             = var.kubernetes_cluster_default_node_pool_min_count
  kubernetes_cluster_default_node_pool_max_count             = var.kubernetes_cluster_default_node_pool_max_count
  kubernetes_cluster_default_node_pool_os_disk_size_gb       = var.kubernetes_cluster_default_node_pool_os_disk_size_gb
  kubernetes_cluster_default_node_pool_os_sku                = var.kubernetes_cluster_default_node_pool_os_sku
  kubernetes_cluster_default_node_pool_max_surge             = var.kubernetes_cluster_default_node_pool_max_surge
  kubernetes_cluster_default_node_pool_availability_zones    = var.kubernetes_cluster_default_node_pool_availability_zones
  kubernetes_cluster_default_node_pool_orchestrator_version  = var.kubernetes_cluster_default_node_pool_orchestrator_version
  kubernetes_cluster_workload_node_pool_vm_size              = var.kubernetes_cluster_workload_node_pool_vm_size
  kubernetes_cluster_workload_node_pool_max_pods             = var.kubernetes_cluster_workload_node_pool_max_pods
  kubernetes_cluster_workload_node_pool_min_count            = var.kubernetes_cluster_workload_node_pool_min_count
  kubernetes_cluster_workload_node_pool_max_count            = var.kubernetes_cluster_workload_node_pool_max_count
  kubernetes_cluster_workload_node_pool_os_disk_size_gb      = var.kubernetes_cluster_workload_node_pool_os_disk_size_gb
  kubernetes_cluster_workload_node_pool_os_sku               = var.kubernetes_cluster_workload_node_pool_os_sku
  kubernetes_cluster_workload_node_pool_max_surge            = var.kubernetes_cluster_workload_node_pool_max_surge
  kubernetes_cluster_workload_node_pool_availability_zones   = var.kubernetes_cluster_workload_node_pool_availability_zones
  kubernetes_cluster_workload_node_pool_orchestrator_version = var.kubernetes_cluster_workload_node_pool_orchestrator_version
  kubernetes_cluster_workload_node_pool_labels               = var.kubernetes_cluster_workload_node_pool_labels
  kubernetes_cluster_workload_node_pool_taints               = var.kubernetes_cluster_workload_node_pool_taints
  kubernetes_cluster_network_plugin                          = var.kubernetes_cluster_network_plugin
  kubernetes_cluster_network_policy                          = var.kubernetes_cluster_network_policy
  kubernetes_cluster_open_service_mesh_enabled               = var.kubernetes_cluster_open_service_mesh_enabled
  kubernetes_cluster_microsoft_defender_enabled              = var.kubernetes_cluster_microsoft_defender_enabled
  kubernetes_cluster_key_vault_secrets_provider_enabled      = var.kubernetes_cluster_key_vault_secrets_provider_enabled
  kubernetes_cluster_oidc_issuer_enabled                     = var.kubernetes_cluster_oidc_issuer_enabled
  kubernetes_cluster_workload_identity_enabled               = var.kubernetes_cluster_workload_identity_enabled
  kubernetes_service_cluster_administrators                  = var.kubernetes_service_cluster_administrators
  kubernetes_service_cluster_users                           = var.kubernetes_service_cluster_users
  kubernetes_service_rbac_administrators                     = var.kubernetes_service_rbac_administrators
  kubernetes_service_rbac_cluster_administrators             = var.kubernetes_service_rbac_cluster_administrators
  kubernetes_service_rbac_readers                            = var.kubernetes_service_rbac_readers
  kubernetes_service_rbac_writers                            = var.kubernetes_service_rbac_writers
  firewall_private_ip_address                                = module.hub.firewall_private_ip_address
  firewall_public_ip_address                                 = module.hub.firewall_public_ip_address
  container_registry_id                                      = module.hub.container_registry_id
}

module "product" {
  count                            = 3
  source                           = "./modules/product"
  resource_suffix                  = local.resource_suffix
  location                         = var.location
  address_space                    = var.product_address_space
  log_analytics_workspace_id       = module.hub.log_analytics_workspace_id
  application_gateway_min_capacity = var.application_gateway_min_capacity
  application_gateway_max_capacity = var.application_gateway_max_capacity
  backend_address_pool_ip_address  = module.spoke.backend_address_pool_ip_address
  number                           = count.index + 1
}

resource "azurerm_virtual_network_peering" "hub_spoke" {
  name                         = "spoke"
  resource_group_name          = module.hub.resource_group_name
  virtual_network_name         = module.hub.virtual_network_name
  remote_virtual_network_id    = module.spoke.virtual_network_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_hub" {
  name                         = "hub"
  resource_group_name          = module.spoke.resource_group_name
  virtual_network_name         = module.spoke.virtual_network_name
  remote_virtual_network_id    = module.hub.virtual_network_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "product_spoke" {
  count                        = 3
  name                         = "spoke"
  resource_group_name          = module.product[count.index].resource_group_name
  virtual_network_name         = module.product[count.index].virtual_network_name
  remote_virtual_network_id    = module.spoke.virtual_network_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_product" {
  count                        = 3
  name                         = "product-${count.index + 1}"
  resource_group_name          = module.spoke.resource_group_name
  virtual_network_name         = module.spoke.virtual_network_name
  remote_virtual_network_id    = module.product[count.index].virtual_network_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
