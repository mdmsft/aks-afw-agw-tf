resource "azurerm_public_ip" "gateway" {
  name                = "pip-${var.resource_suffix}-agw"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_web_application_firewall_policy" "main" {
  name                = "waf-${var.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
    request_body_check          = true
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "agw-${var.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.main.id
  enable_http2        = true

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.application_gateway_min_capacity
    max_capacity = var.application_gateway_max_capacity
  }

  backend_address_pool {
    name         = "default"
    ip_addresses = [var.backend_address_pool_ip_address]
  }

  backend_http_settings {
    name                  = "default"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    probe_name            = "default"
    host_name             = "foo.bar"
  }

  frontend_ip_configuration {
    name                 = "default"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }

  gateway_ip_configuration {
    name      = "default"
    subnet_id = azurerm_subnet.application_gateway.id
  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "default"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  frontend_port {
    name = "http"
    port = 80
  }

  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    priority                   = 1
    backend_http_settings_name = "default"
    backend_address_pool_name  = "default"
  }

  probe {
    name                                      = "default"
    interval                                  = 30
    protocol                                  = "Http"
    path                                      = "/healthz"
    pick_host_name_from_backend_http_settings = true
    timeout                                   = 3
    unhealthy_threshold                       = 3
  }
}
