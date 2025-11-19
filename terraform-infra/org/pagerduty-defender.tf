####################################
# Defender Service Configuration   #
####################################

resource "pagerduty_service" "defender" {
  name                    = format("%s-defender", local.project)
  acknowledgement_timeout = "null"
  auto_resolve_timeout    = "null"
}

resource "pagerduty_service_integration" "defender" {
  name    = "Defender Alerts"
  vendor  = data.pagerduty_vendor.azure.id
  service = pagerduty_service.defender.id
}


module "user_notifications" {
  source = "../modules/pagerduty_user_notifications"

  providers = {
    http.pagerduty = http.pagerduty
  }

  environment     = local.environment
  users           = local.pagerduty_users
  pagerduty_token = var.pagerduty_token
}

