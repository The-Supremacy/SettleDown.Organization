locals {
  env = "dev"
  shared_rg_name = "rg-settledown-shared-${env}-ne-001"
  shared_app_identity_name = "id-settledown-shared-${env}-001"
  aca_environment_name = "cae-settledown-${env}-001"
  acr_rg_name = "rg-settledown-acr-shd-ne-001"
  acr_name = "crssdshdne001"
}

resource "azurerm_resource_group" "acr_rg" {
  name     = "rg-settledown-organization-${local.env}-ne-001"
  location = "North Europe"
  tags = {
    Area = "Shared"
  }
}

module "organization" {
  source   = "../../modules/organization"
  rg_name  = azurerm_resource_group.acr_rg.name
  shared_rg_name = local.shared_rg_name
  shared_app_identity_name = local.shared_app_identity_name
  aca_environment_name = local.aca_environment_name
  acr_rg_name = local.acr_rg_name
  acr_name = local.acr_name
  image_label = var.image_label
  location = azurerm_resource_group.acr_rg.location
  env      = local.env
}
