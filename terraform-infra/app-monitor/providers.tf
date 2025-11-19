provider "azapi" {
  tenant_id        = var.azure_tenant_id     # ARM_TENANT_ID
  client_id        = var.azure_client_id     # ARM_CLIENT_ID
  client_secret    = var.azure_client_secret # ARM_CLIENT_SECRET
  environment      = "public"                # ARM_ENVIRONMENT
  default_tags     = local.common_tags
  default_location = local.location
}

provider "azuread" {
  tenant_id     = var.azure_tenant_id     # ARM_TENANT_ID
  client_id     = var.azure_client_id     # ARM_CLIENT_ID
  client_secret = var.azure_client_secret # ARM_CLIENT_SECRET
  environment   = "public"                # ARM_ENVIRONMENT
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id # ARM_SUBSCRIPTION_ID
  tenant_id       = var.azure_tenant_id       # ARM_TENANT_ID
  client_id       = var.azure_client_id       # ARM_CLIENT_ID
  client_secret   = var.azure_client_secret   # ARM_CLIENT_SECRET
  environment     = "public"                  # ARM_ENVIRONMENT
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = true
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}

provider "http" {
  alias = "pagerduty"
}
