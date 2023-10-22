resource "azurerm_log_analytics_workspace" "workspace" {
  name                            = var.log_analytics_workspace_name
  resource_group_name             = var.rg_name
  location                        = var.location
  sku                             = "PerGB2018"
  retention_in_days               = 30
  allow_resource_only_permissions = true
  tags = {
    Area        = "Organization"
    Environment = "Dev"
  }
}