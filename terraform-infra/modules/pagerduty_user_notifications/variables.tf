variable "environment" {
  type        = string
  description = "The deployment environment (e.g., 'prod', 'staging', 'dev')."
}

variable "users" {
  type = map(object({
    id    = string
    email = string
    name  = string
  }))
  description = "A map of PagerDuty users to configure notification rules for."
}

variable "pagerduty_token" {
  type        = string
  description = "The PagerDuty API token."
  sensitive   = true
}
