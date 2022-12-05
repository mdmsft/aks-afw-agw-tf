output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "backend_address_pool_ip_address" {
  value = cidrhost(azurerm_subnet.cluster.address_prefixes[0], 254)
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}
