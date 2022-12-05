variable "resource_suffix" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = string
}

variable "nat_gateway_public_ip_prefix_length" {
  type = number
}

variable "log_analytics_workspace_daily_quota_gb" {
  type = number
}

variable "log_analytics_workspace_retention_in_days" {
  type = number
}

variable "container_registry_sku" {
  type = string
}
