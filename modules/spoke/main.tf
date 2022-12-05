resource "azurerm_resource_group" "main" {
  name     = "rg-${var.resource_suffix}-spoke"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
