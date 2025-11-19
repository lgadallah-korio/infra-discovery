###################################
# MongoDB Service Configuration   #
###################################

resource "pagerduty_service" "mongodb" {
  name                    = format("%s-%s", local.name_prefix, "mongodb")
  acknowledgement_timeout = "null"
  auto_resolve_timeout    = "null"

  incident_urgency_rule {
    type    = "constant"
    urgency = (local.environment == "prod" || local.environment == "prod3") ? "severity_based" : "low"
  }
}

resource "pagerduty_service_integration" "mongodb" {
  name    = "MongoDB Cloud Alerts"
  vendor  = data.pagerduty_vendor.mongodb_metrics.id
  service = pagerduty_service.mongodb.id
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

