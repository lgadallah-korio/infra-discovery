terraform {
  required_version = "1.10.5"

  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.15.2"
    }
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.12.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}
