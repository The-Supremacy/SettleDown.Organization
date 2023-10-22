variable "env" {
}

variable "rg_name" {
}

variable "aca_environment_id" {
}

variable "acr_login_server" {
}

variable "acr_admin_username" {
}

variable "acr_admin_password" {
  sensitive = true
}

variable "log_workspace_id" {
}

variable "app_name" {
}

variable "image_name" {
}

variable "image_label" {
}

variable "location" {
}

variable "shared_app_identity_principal_id" {
}

variable "enable_ingress" {
  default = true
}

variable "is_external_ingress" {
  default = false
}

variable "target_port" {
  default = 80
}

variable "min_replicas" {
  default = 0
}

variable "max_replicas" {
  default = 10
}

variable "secrets" {
  type      = list
  sensitive = true
  default   = []
}

variable "env_variables" {
  type    = list
  default = []
}

variable "revision_mode" {
  default = "Single"
}

variable "cpu" {
  default = "0.5"
}

variable "memory" {
  default = "1.0Gi"
}

variable "use_readiness_probe" {
  default = false
}

variable "http_scale_rules" {
  default = []
}

variable "custom_scale_rules" {
  default = []
}