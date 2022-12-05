resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "cluster" {
  name                 = "snet-aks"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [cidrsubnet(var.address_space, 0, 0)]
}

resource "azurerm_network_security_group" "cluster" {
  name                = "nsg-${var.resource_suffix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "cluster" {
  network_security_group_id = azurerm_network_security_group.cluster.id
  subnet_id                 = azurerm_subnet.cluster.id
}

resource "azurerm_route_table" "cluster" {
  name                = "rt-${var.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "net-to-afw"
    address_prefix         = "0.0.0.0/0"
    next_hop_in_ip_address = var.firewall_private_ip_address
    next_hop_type          = "VirtualAppliance"
  }

  route {
    name           = "afw-to-www"
    address_prefix = "${var.firewall_public_ip_address}/32"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "cluster" {
  subnet_id      = azurerm_subnet.cluster.id
  route_table_id = azurerm_route_table.cluster.id
}
