output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}
