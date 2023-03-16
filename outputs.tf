output "r_g_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_acct_name" {
  value = azurerm_storage_account.aznamingstgacc.name
}

output "storage_shar_name" {
  value = azurerm_storage_share.aznamingtool.name
}

output "container_reg_name" {
  value = azurerm_container_registry.acr.name
}
output "container_url" {
 value = var.deployment_option == "container_instance" ? azurerm_container_group.aznamingtool-container-app[0].fqdn : "Not using container_instance deployment_option"
 description = "URL used to access AZNamingTool once deployed."
}
