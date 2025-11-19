terraform {
  required_version = "1.10.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.15.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.1"
    }
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.12.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.60.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}
