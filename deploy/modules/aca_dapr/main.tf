resource "azurerm_user_assigned_identity" "container_app_identity" {
  name                = "id-settledown-${var.app_name}-${var.env}-001"
  resource_group_name = var.rg_name
  location            = var.location
}

module "app_ai" {
  source           = "../application_insights_loganalytics"
  rg_name          = var.rg_name
  ai_name          = "appi-settledown-${var.app_name}-${var.env}-001"
  location         = var.location
  log_workspace_id = var.log_workspace_id
}

resource "azurerm_container_app" "my_first_app" {
  name                = var.app_name
  resource_group_name = var.rg_name

  container_app_environment_id = var.aca_environment_id
  revision_mode                = var.revision_mode

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.shared_app_identity_principal_id,
      azurerm_user_assigned_identity.container_app_identity.principal_id
    ]
  }

  dynamic "secret" {
    for_each = concat(var.secrets, [{
      name  = "appinsights-key",
      value = "appInsights.properties.InstrumentationKey"
      },
      {
        name  = "containerregistrypassword",
        value = var.acr_admin_password
    }])
    content {
      name  = secrets.name
      value = secrets.value
    }
  }

  registry {
    server               = var.acr_login_server
    username             = var.acr_admin_username
    password_secret_name = "containerregistrypassword"
  }

  template {
    container {
      name   = var.app_name
      image  = "${var.acr_login_server}/${var.image_name}:${var.image_label}"
      cpu    = var.cpu
      memory = var.memory
      dynamic "use_readiness_probe" {
        for_each = var.use_readiness_probe ? [1] : []
        content {
          port                    = var.port
          path                    = "/api/health/readiness"
          transport               = "http"
          failure_count_threshold = 3
        }
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    dynamic "http_scale_rule" {
      for_each = var.http_scale_rules
      content {
        name                = http_scale_rules.name
        concurrent_requests = http_scale_rules.concurrent_requests
      }
    }

    dynamic "custom_scale_rule" {
      for_each = var.http_scale_rules
      content {
        name             = http_scale_rules.name
        custom_rule_type = http_scale_rules.cuscustom_rule_type
        metadata         = http_scale_rules.metadata
        dynamic "authentication" {
          for_each = http_scale_rules.authentication
          content {
            secret_name       = http_scale_rules.authentication.secret_name
            trigger_parameter = http_scale_rules.authentication.trigger_parameter
          }
        }
      }
    }

    dynamic "env" {
      for_each = concat(var.env_variables, [{
        name        = "ApplicationInsights__InstrumentationKey",
        secret_name = "appinsights-key"
      }])
      content {
        name        = env_variables.name
        value       = env_variables.value
        secret_name = env_variables.secret_name
      }
    }
  }

  dapr {
    app_id   = var.app_name
    app_port = var.target_port
  }

  dynamic "ingress" {
    for_each = var.enable_ingress ? [1] : []
    content {
      external_enabled = var.is_external_ingress
      target_port      = 80
      traffic_weight {
        percentage = 100
      }
    }
  }
}