terraform-azurerm-aznamingtool
==============================

This module deploys the Azure Naming Tool, a .NET Core-based utility that generates Azure resource names before provisioning. It allows deployment as either an Azure App Service or a Container Instance, based on the value of the `deployment_option` variable.

The tool's image is sourced from the ACR created by this module, regardless of the chosen deployment option. For App Service deployment, users can opt for an App Service Environment based on the value of the `use_ase` variable.

 - Official Azure Cloud Adoption / Az Naming Tool Github Repo: https://github.com/microsoft/CloudAdoptionFramework/tree/master/ready/AzNamingTool

Usage
-----

1.  Add the module to your Terraform configuration:

```hcl:

module "aznamingtool" {
  source = "github.com/your-org/terraform-azurerm-aznamingtool"
  location         = "EastUS"
  deployment_option = "container_instance"
  business_description = "AzNamingTool"
  res_creator_account  = "John Doe"
  release_env          = "DEV"
  resource_category    = "Tools"
  res_app_family       = "Cloud-Core"
 }
```

2.  Run `terraform init` to initialize the Terraform working directory and download the required provider plugins.

3.  Run `terraform apply` to deploy the AzNamingTool to your Azure subscription.

Resources Created
-----------------

-   Resource Group
-   Storage Account and File Share
-   Container Registry (ACR) with Admin Credentials
-   Private Container Registry Task, can toggle if enabled or not via `acr_task_enabled` variable
-   Azure Container Instance or Azure App Service based on the value of `deployment_option` variable
-   Private Container Registry Task, if `acr_task_enabled` is set to `true`
-   App Service Environmentis used by ASP if `use_ase` is set to `true`
-   Linux Web App only if`deployment_option` is set to `app_service`

Note: The `App Service Environment` resource is used only if the `use_ase` variable is set to `true`. The `App Service Plan` and `Web App` resources are only created if the `deployment_option` is set to `app_service`.


Inputs
------

-   `location`: The location where the resources will be deployed.
-   `deployment_option`: Choose the deployment option for the application: 'container_instance' for an Azure Container Instance or 'app_service' for an Azure App Service within an App Service Environment (ASE).
-   `rg`: The name of the CIE resource group.
-   `business_description`: The business description tag for the Azure Resource Group resources.
-   `res_creator_account`: The res creator account tag for the Azure Resource Group resources.
-   `release_env`: The release environment tag for the Azure Resource Group resources.
-   `resource_category`: The resource category tag for the Azure Resource Group resources.
-   `res_app_family`: The res app family tag for the Azure Resource Group resources.
-   `account_tier`: The storage account tier.
-   `account_replication_type`: The storage account replication type.
-   `delete_retention_days`: The number of days to retain deleted blobs.
-   `default_service_version`: The default service version to use for new storage accounts.
-   `quota`: The Azure file share quota.
-   `enabled_protocol`: The Azure file share enabled protocol.
-   `namingtool_config_share_name`: The name of the Azure file share for the naming tool config files.
-   `container_cpu`: The CPU allocation for the container.
-   `container_memory`: The memory allocation for the container.
-   `container_port`: The port to expose on the container.
-   `container_protocol`: The protocol to use for the container port.
-   `image_tag`: The tag of the container image.
-   `namingtool_container_name`: The name of the Azure container instance for the naming tool.
-   `os_type`: The operating system to use for the container.
-   `byte_length`: The length of the random ID suffix to add to the storage account name.
-   `name_prefix`: The prefix to use for the storage account name.
-   `aznamingtool_share_name`: The name of the Azure file share for the naming tool.
-   `use_ase`: value to use ASE or not.
-   `ase_name`: The name of the ASE.
-   `ase_rg`: The name of the ASE resource group.
-   `asp_name`: The name of the App Service Plan.
-   `sku_name`: The name of the App Service Plan SKU.
-   `zone_balancing_enabled`: The zone balancing enabled flag.
-   `acr_admin_enabled`: The ACR admin enabled flag.
-   `acr_name`: The name of the ACR.
-   `acr_sku`: The SKU of the ACR.
-   `acr_task_name`: The name of the ACR task.
-   `acr_task_enabled`: The ACR task enabled flag.
-   `container_subnet_name`: The name of the container subnet.
-   `container_vnet_name`: The name of the container vnet.
-   `container_platform_os`: The operating system to use for the container (use Linux for AZNamingTool).
-   `dockerfile_path`: The path to the Dockerfile.
-   `context_path`: The path to the context.
-   `image_name`: The container image.
-   `github_pat`: The GitHub personal access token for the context path within docker_step.
-   `acr_admin_username`: The admin username for the container.
-   `acr_admin_password`: The admin password for the container registry.
-   `aznamingtool_webapp_name`: The name of the Azure web app for the naming tool.
-   `allowed_ip_addresses`: The list of IP addresses allowed to access the web app.
-   `dns_name_label`: The DNS name label for the container and the web app.

Outputs
-------

-   `resource_group_name`: The name of the resource group created by the module.
-   `storage_account_name`: The name of the storage account created by the module.
-   `storage_account_key`: The access key for the storage account created by the module.
-   `file_share_name`: The name of the file share created by the module.
-   `container_instance_name`: The name of the container instance created by the module (if using container_instance deployment_option).
-   `container_instance_ip_address`: The public IP address of the container instance created by the module (if using container_instance deployment_option).
-   `app_service_name`: The name of the app service created by the module (if using app_service deployment_option).
-   `app_service_default_hostname`: The default hostname of the app service created by the module (if using app_service deployment_option).
-   `app_service_ip_addresses`: The IP addresses of the app service created by the module (if using app_service deployment_option).
-   `app_service_hostname`: The hostname of the app service created by the module (if using app_service deployment_option).

 