resource "azurerm_resource_group" "main" {
  name     = "rg-${var.resource_suffix}-product-${var.number}"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
