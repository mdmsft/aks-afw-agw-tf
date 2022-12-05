output "firewall_private_ip_address" {
  value = azurerm_firewall.main.ip_configuration.0.private_ip_address
}

output "firewall_public_ip_address" {
  value = azurerm_public_ip.firewall.ip_address
}

output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "container_registry_id" {
  value = azurerm_container_registry.main.id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}
