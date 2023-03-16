// General settings
variable "location" {
  description = "The location where the resources will be deployed"
}
variable "deployment_option" {
  description = "Choose the deployment option for the application: 'container_instance' for an Azure Container Instance or 'app_service' for an Azure App Service within an App Service Environment (ASE)."
  # default     = "container_instance"
}
variable "rg" {
  description = "The name of the resource group where all resources for the aznamingtool will be deployed."
  type        = string
  default     = "AzNamingTool-DEV"
}

// Resource group tags - meant to be applied to the rg and have policy enforce them on all resources in the rg - that is why you see the ignore_changes on the rg resource within the main.tf
variable "business_description" {
  type        = string
  description = "The business description tag for the Azure Resource Group resources"
}
variable "creator_account" {
  type        = string
  description = "The res creator account tag for the Azure Resource Group resources"
}
variable "release_env" {
  type        = string
  description = "The release environment tag for the Azure Resource Group resources"
}
variable "resource_category" {
  type        = string
  description = "The resource category tag for the Azure Resource Group resources"
}
variable "res_app_family" {
  type        = string
  description = "The res app family tag for the Azure Resource Group resources"
}


// Storage Account / Share settings
variable "account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"
}
variable "account_replication_type" {
  description = "The storage account replication type"
  type        = string
  default     = "LRS"
}
variable "delete_retention_days" {
  description = "The number of days to retain deleted blobs"
  type        = number
  default     = 7
}
variable "default_service_version" {
  description = "The default service version to use for new storage accounts"
  type        = string
  default     = "2019-02-02"
}
variable "quota" {
  description = "The Azure file share quota"
  type        = number
  default     = 100
}
variable "enabled_protocol" {
  description = "The Azure file share enabled protocol"
  type        = string
  default     = "SMB"
}
variable "namingtool_config_share_name" {
  description = "The name of the Azure file share for the naming tool config files"
  type        = string
  default     = "namingtool-config"
}

// Container settings
variable "container_cpu" {
  description = "The CPU allocation for the container"
  type        = number
  default     = 2
}
variable "container_memory" {
  description = "The memory allocation for the container"
  type        = number
  default     = 2
}
variable "container_port" {
  description = "The port to expose on the container"
  type        = number
  default     = 80
}
variable "container_protocol" {
  description = "The protocol to use for the container port"
  type        = string
  default     = "TCP"
}
variable "image_tag" {
  description = "The tag of the container image"
  type        = string
  default     = "latest"
}
variable "namingtool_container_name" {
  description = "The name of the Azure container instance for the naming tool"
  type        = string
  default     = "aznamingtool-container"
}
variable "os_type" {
  description = "The operating system to use for the container"
  type        = string
  default     = "Linux"
}

// Storage account naming settings
variable "byte_length" {
  description = "The length of the random ID suffix to add to the storage account name."
  type        = number
  default     = 3
}
variable "name_prefix" {
  description = "The prefix to use for the storage account name."
  type        = string
  default     = "aznamingtool"
}
variable "aznamingtool_share_name" {
  description = "The name of the Azure file share for the naming tool"
  type        = string
  default     = "aznamingtool"
}

// App Service Environment settings
variable "use_ase" {
  description = "value to use ASE or not"
  type        = bool
  default     = true
}
variable "ase_name" {
  description = "The name of the ASE"
  type        = string
  default     = "ASE1"
}
variable "ase_rg" {
  description = "The name of the ASE resource group"
  type        = string
  default     = "ASE-RG"
}

// App Service Plan settings
variable "asp_name" {
  description = "The name of the App Service Plan"
  type        = string
  default     = "aznamingtool-asp"
}
variable "sku_name" {
  description = "The name of the App Service Plan SKU"
  type        = string
  default     = "I1v2"
}
variable "zone_balancing_enabled" {
  description = "The zone balancing enabled flag"
  type        = bool
  default     = true
}

// Container Registry / Container Task settings
variable "acr_admin_enabled" {
  description = "The ACR admin enabled flag"
  type        = bool
  default     = true
}
variable "acr_name" {
  description = "The name of the ACR"
  type        = string
  default     = "aznamingtoolacrdev"
}
variable "acr_sku" {
  description = "The SKU of the ACR"
  type        = string
  default     = "Standard"
}
variable "aznamingtool_container_name" {
  description = "The name of the Azure container instance for the naming tool"
  type        = string
  default     = "aznamingtool-dev-container"
}
variable "container_image" {
  description = "The container image"
  type        = string
  default     = "aznamingtoolacrdev.azurecr.io/aznamingtool-dev-container:latest"
}
variable "container_os_type" {
  description = "The operating system to use for the container"
  type        = string
  default     = "Linux"
}
variable "acr_task_name" {
  description = "The name of the ACR task"
  type        = string
  default     = "aznamingtool-dev-container"
}
variable "acr_task_enabled" {
  description = "The ACR task enabled flag"
  type        = bool
  default     = true
}

// Container network / platform settings
variable "container_subnet_name" {
  description = "The name of the container subnet"
  type        = string
}
variable "container_vnet_name" {
  description = "The name of the container vnet"
  type        = string
}
variable "container_platform_os" {
  description = "The operating system to use for the container (use Linux for AZNamingTool)"
  type        = string
  default     = "Linux"
}
//docker_step settings
variable "dockerfile_path" {
  description = "The path to the Dockerfile"
  type        = string
  default     = "Dockerfile"
}
variable "context_path" {
  description = "The path to the repo where the source code is located including the Dockerfile"
  type        = string
  default     = "https://github.com/rclittler/AZNamingTool"
}
variable "image_name" {
  default = "aznamingtoolacrdev.azurecr.io/aznamingtool-dev-container:latest"
}
// Github settings (within docker_step)
variable "github_pat" {
  description = "The GitHub personal access token for the context path within docker_step"
  type = string
  }

// ACR admin credentials
variable "acr_admin_username" {
  description = "The admin username for the container"
  type        = string
  default     = "admin-aznamingtool"
}
variable "acr_admin_password" {
  description = "The admin password for the container registry"
  type        = string
  default     = "ARegistryIsSecure!"
}

// Web App settings
variable "aznamingtool_webapp_name" {
  description = "The name of the Azure web app for the naming tool"
  type        = string
  default     = "aznamingtool-dev-webapp"
}
variable "allowed_ip_addresses" {
  description = "The list of public IP addresses allowed to access the web app"
  type        = list(string)
  default     = ["0.0.0.0"]
}
variable "website_port" {
  description = "The port to use for the web app"
  type        = number
  default     = 80
}

// DNS settings
variable "dns_name_label" {
  description = "The DNS name label for the container and the web app"
  type        = string
  default     = "aznamingtool-dev"
}
