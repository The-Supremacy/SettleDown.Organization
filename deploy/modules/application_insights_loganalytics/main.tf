resource "azurerm_application_insights" "ai" {
  name                = var.ai_name
  location            = var.location
  resource_group_name = var.rg_name
  workspace_id        = var.log_workspace_id
  application_type    = "web"

  tags = {
    Area        = "Shared infrastructure"
    Environment = "Dev"
  }
}