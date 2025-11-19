terraform {
  required_providers {
    pagerduty = {
      source = "pagerduty/pagerduty"
    }
    http = {
      source                = "hashicorp/http"
      version               = "~> 3.4"
      configuration_aliases = [http.pagerduty]
    }
  }
}
