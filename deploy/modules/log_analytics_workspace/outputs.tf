output "log_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "log_name" {
  value = azurerm_log_analytics_workspace.workspace.name
}

output "log_primary_key" {
  value = azurerm_log_analytics_workspace.workspace.primary_shared_key
}
output "log_workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.workspace_id

}