resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "application_gateway" {
  name                 = "snet-agw"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [cidrsubnet(var.address_space, 0, 0)]
}

resource "azurerm_network_security_group" "application_gateway" {
  name                = "nsg-${var.resource_suffix}-agw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                         = "AllowInternetIn"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443"]
    source_address_prefix        = "Internet"
    destination_address_prefixes = azurerm_subnet.application_gateway.address_prefixes
  }

  security_rule {
    name                       = "AllowGatewayManagerIn"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerIn"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "application_gateway" {
  network_security_group_id = azurerm_network_security_group.application_gateway.id
  subnet_id                 = azurerm_subnet.application_gateway.id
}
