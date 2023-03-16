# Create resource group to house all resources with specified tags.
resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
  tags = {
    "BusinessDescription" = var.business_description
    "resCreatorAccount"   = var.res_creator_account
    "ReleaseEnv"          = var.release_env
    "ResourceCategory"    = var.resource_category
    "resAppFamily"        = var.res_app_family
  }
}
# generate a random string to be used as a suffix for the storage account name
resource "random_id" "name_suffix" {
  byte_length = var.byte_length
}
# Create storage account to house the file share.
resource "azurerm_storage_account" "aznamingstgacc" {
  name                     = "${lower(var.name_prefix)}${random_id.name_suffix.hex}"
  resource_group_name      = var.rg
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  blob_properties {
    delete_retention_policy {
      days = var.delete_retention_days
    }
    default_service_version = var.default_service_version
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}
# Create file share to house the aznamingtool files.
resource "azurerm_storage_share" "aznamingtool" {
  name                 = var.aznamingtool_share_name
  storage_account_name = azurerm_storage_account.aznamingstgacc.name
  quota                = var.quota
  enabled_protocol     = var.enabled_protocol
  depends_on = [
    azurerm_resource_group.rg, azurerm_storage_account.aznamingstgacc
  ]
}
# Create container registry to house the aznamingtool docker image.
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  depends_on = [
    azurerm_resource_group.rg
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
# Create container registry task to build the aznamingtool docker image.
resource "azurerm_container_registry_task" "aznamingtool_task" {
  name                  = var.acr_task_name
  container_registry_id = azurerm_container_registry.acr.id
  enabled               = var.acr_task_enabled
  depends_on = [
    azurerm_container_registry.acr
  ]
  platform {
    os = var.container_platform_os
  }
  # The following is the docker build step
  docker_step {
    dockerfile_path      = var.dockerfile_path
    context_path         = var.context_path
    context_access_token = var.github_pat
    image_names          = [var.image_name]
  }
}
# Create container registry task trigger to run the aznamingtool docker image build.
resource "azurerm_container_registry_task_schedule_run_now" "run_aznamingtool_build" {
  container_registry_task_id = azurerm_container_registry_task.aznamingtool_task.id
  depends_on = [
    azurerm_container_registry_task.aznamingtool_task
  ]
}
# Output ASE ID for use with the app service plan resource
data "azurerm_app_service_environment_v3" "ase" {
  name                = var.ase_name
  resource_group_name = var.ase_rg
}
output "ase_id" {
  value = data.azurerm_app_service_environment_v3.ase.id
}
# App Service Plan for AzNamingTool web app
resource "azurerm_service_plan" "aznamingtool-asp" {
  # Only create the app service plan if the "deployment_option" variable is set to "app_service"
  count               = var.deployment_option == "app_service" ? 1 : 0
  name                = var.asp_name
  resource_group_name = var.rg
  location            = var.location
  # Only include the app_service_environment_id attribute if the "use_ase" variable is true
  app_service_environment_id = var.use_ase ? data.azurerm_app_service_environment_v3.ase.id : null
  sku_name                   = var.sku_name
  os_type                    = var.os_type
  zone_balancing_enabled     = var.zone_balancing_enabled
  depends_on = [
    azurerm_resource_group.rg
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
# Web App for AzNamingTool
resource "azurerm_linux_web_app" "aznamingtool_web_app" {
  # Only create the web app if the "deployment_option" variable is set to "app_service"
  count               = var.deployment_option == "app_service" ? 1 : 0
  name                = var.aznamingtool_webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.aznamingtool-asp[count.index].id
  storage_account {
    name         = azurerm_storage_account.aznamingstgacc.name
    type         = "AzureFiles"
    account_name = azurerm_storage_account.aznamingstgacc.name
    access_key   = azurerm_storage_account.aznamingstgacc.primary_access_key
    share_name   = azurerm_storage_share.aznamingtool.name
    mount_path   = "/mnt/${var.aznamingtool_share_name}"
  }

  site_config {
    always_on                = true
    app_command_line         = ""
    remote_debugging_enabled = false
  }
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
    "WEBSITES_PORT"                       = var.website_port
    "DOCKER_CUSTOM_IMAGE_NAME"            = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.aznamingtool_container_name}:latest"
    # "SCM_TYPE"                            = "None" #source control used for deployment
    # DOCKER_ENABLE_CI                       = "true" # enable continuous integration
  }
  depends_on = [
    azurerm_container_registry_task.aznamingtool_task
  ]

}
# Create container group for AzNamingTool container app
resource "azurerm_container_group" "aznamingtool-container-app" {
  # Only create the container group if the "deployment_option" variable is set to "container_instance"
  count               = var.deployment_option == "container_instance" ? 1 : 0
  name                = var.aznamingtool_container_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = var.container_os_type
  dns_name_label      = var.dns_name_label
  # image registry credentials from the container registry
  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
  container {
    name   = var.aznamingtool_container_name
    image  = "${azurerm_container_registry.acr.login_server}/${var.aznamingtool_container_name}:latest"
    cpu    = var.container_cpu
    memory = var.container_memory
    ports {
      port     = var.container_port
      protocol = var.container_protocol
    }
    # storage volume mount from the storage account and file share
    volume {
      name                 = var.aznamingtool_share_name
      mount_path           = "/mnt/${var.aznamingtool_share_name}"
      storage_account_name = azurerm_storage_account.aznamingstgacc.name
      storage_account_key  = azurerm_storage_account.aznamingstgacc.primary_access_key
      share_name           = azurerm_storage_share.aznamingtool.name
    }
  }
  depends_on = [
    azurerm_container_registry_task.aznamingtool_task, azurerm_container_registry_task_schedule_run_now.run_aznamingtool_build
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
