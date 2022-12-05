resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [cidrsubnet(var.address_space, 0, 0)]
}

resource "azurerm_public_ip_prefix" "firewall" {
  name                = "ippre-${var.resource_suffix}-afw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  prefix_length       = var.nat_gateway_public_ip_prefix_length
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_nat_gateway" "firewall" {
  name                    = "ng-${var.resource_suffix}-afw"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  idle_timeout_in_minutes = 4
  sku_name                = "Standard"
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "firewall" {
  nat_gateway_id      = azurerm_nat_gateway.firewall.id
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall.id
}

resource "azurerm_subnet_nat_gateway_association" "firewall" {
  nat_gateway_id = azurerm_nat_gateway.firewall.id
  subnet_id      = azurerm_subnet.firewall.id
}
