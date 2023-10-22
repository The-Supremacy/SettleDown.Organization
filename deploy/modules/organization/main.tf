data "azurerm_container_registry" "acr" {
  provider            = azurerm.shared
  name                = var.acr_name
  resource_group_name = var.acr_rg_name
  location            = var.location
}

data "azurerm_container_app_environment" "aca_environment" {
  name                = var.aca_environment_name
  resource_group_name = var.shared_rg_name
  location            = var.location
}

data "azurerm_user_assigned_identity" "shared_app_identity" {
  name                = var.shared_app_identity_name
  resource_group_name = var.rg_name
  location            = var.location
}

module "log_analytics_workspace" {
  source                       = "../log_analytics_workspace"
  rg_name                      = var.rg_name
  log_analytics_workspace_name = "log-settledown-org-${var.env}-001"
  location                     = var.location
}

module "org_api_aca" {
  source                   = "../aca_dapr"
  env                      = var.env
  rg_name                  = var.rg_name
  aca_environment_id        = data.azurerm_container_app_environment.aca_environment.id
  acr_login_server = data.azurerm_container_registry.acr.login_server
  acr_admin_username = data.azurerm_container_registry.acr.admin_username
  acr_admin_password = data.azurerm_container_registry.acr.admin_password
  log_workspace_id         = module.log_analytics_workspace.log_id
  app_name                 = "organization-api"
  image_name               = "organization-api"
  image_label              = var.image_label
  location                 = var.location
  shared_app_identity_principal_id = data.azurerm_user_assigned_identity.principal_id
  is_external_ingress      = true // change later
}