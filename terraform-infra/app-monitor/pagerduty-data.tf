module "user_notifications" {
  source = "../modules/pagerduty_user_notifications"

  providers = {
    http.pagerduty = http.pagerduty
  }

  environment     = local.environment
  users           = local.pagerduty_users
  pagerduty_token = var.pagerduty_token
}
