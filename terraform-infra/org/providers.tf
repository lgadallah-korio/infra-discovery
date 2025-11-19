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

provider "github" {
  owner = "korio-clinical"

  app_auth {
    id              = var.github_provider_app_id              # or `GITHUB_APP_ID`
    installation_id = var.github_provider_app_installation_id # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = var.github_provider_app_pem             # or `GITHUB_APP_PEM_FILE`
  }

  # https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api
  # 5,000 requests per hour and 900 points per minute are allowed. Read = 1, Write = 5.
  read_delay_ms  = 80  # 60.000 ms / 900 = 67
  write_delay_ms = 400 # 60.000ms / (900/5) = 334
  max_retries    = 5
  retry_delay_ms = 1500
}

provider "pagerduty" {
  token = var.pagerduty_token
}

provider "http" {
  alias = "pagerduty"
}

provider "tfe" {
  organization = "korio-clinical"
}
