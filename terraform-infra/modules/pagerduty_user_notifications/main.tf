#
# PagerDuty User Contact Methods
#
# This data source uses the PagerDuty API directly via the HTTP provider
# because the PagerDuty Terraform provider's data source for contact methods
# has breaking changes in v3.x that make it impossible to look up a contact
# method without knowing its label in advance. This approach is more resilient.
#

data "http" "contact_methods" {
  for_each = var.users
  url      = "https://api.pagerduty.com/users/${each.value.id}/contact_methods"
  provider = http.pagerduty

  request_headers = {
    Accept        = "application/vnd.pagerduty+json;version=2"
    Authorization = "Token token=${var.pagerduty_token}"
    Content-Type  = "application/json"
  }
}

locals {
  # Create a map of users to their various contact method IDs.
  # We find the first contact method that matches a given type.
  # The `try` function provides a `null` fallback if a contact method is not found for a user,
  # preventing the plan from failing.
  user_contact_method_ids = {
    for user_key, user in var.users : user_key => {
      email = try(one([
        for cm in jsondecode(data.http.contact_methods[user_key].response_body).contact_methods : cm.id
        if cm.type == "email_contact_method_reference"
      ]), null)
      phone = try(one([
        for cm in jsondecode(data.http.contact_methods[user_key].response_body).contact_methods : cm.id
        if cm.type == "phone_contact_method_reference"
      ]), null)
      sms = try(one([
        for cm in jsondecode(data.http.contact_methods[user_key].response_body).contact_methods : cm.id
        if cm.type == "sms_contact_method_reference"
      ]), null)
      teams = try(one([
        for cm in jsondecode(data.http.contact_methods[user_key].response_body).contact_methods : cm.id
        if cm.type == "teams_contact_method_reference"
      ]), null)
      push = try(one([
        for cm in jsondecode(data.http.contact_methods[user_key].response_body).contact_methods : cm.id
        if cm.type == "push_notification_contact_method_reference"
      ]), null)
    }
  }
}

#############################
# Notification Rules        #
#############################

# Production (prod, prod3): Push notifications (high urgency, immediate)
resource "pagerduty_user_notification_rule" "prod_push" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "prod" || var.environment == "prod3") && local.user_contact_method_ids[k].push != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 0
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].push
    type = "push_notification_contact_method"
  }
}

# Production (prod, prod3): Phone notifications (high urgency, 1 min delay)
resource "pagerduty_user_notification_rule" "prod_phone" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "prod" || var.environment == "prod3") && local.user_contact_method_ids[k].phone != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 1
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].phone
    type = "phone_contact_method"
  }
}

# Production (prod, prod3): SMS notifications (high urgency, 5 min delay)
resource "pagerduty_user_notification_rule" "prod_sms" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "prod" || var.environment == "prod3") && local.user_contact_method_ids[k].sms != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 5
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].sms
    type = "sms_contact_method"
  }
}

# Production (prod, prod3): Email notifications (high urgency, 10 min delay)
resource "pagerduty_user_notification_rule" "prod_email" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "prod" || var.environment == "prod3") && local.user_contact_method_ids[k].email != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 10
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].email
    type = "email_contact_method"
  }
}

# Production (prod, prod3): Teams notifications (high urgency, 1 min delay for visibility)
resource "pagerduty_user_notification_rule" "prod_teams" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "prod" || var.environment == "prod3") && local.user_contact_method_ids[k].teams != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 1
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].teams
    type = "teams_contact_method"
  }
}

# Staging (staging, staging3): SMS notifications (high urgency, 5 min delay)
resource "pagerduty_user_notification_rule" "staging_sms" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "staging" || var.environment == "staging3") && local.user_contact_method_ids[k].sms != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 5
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].sms
    type = "sms_contact_method"
  }
}

# Staging (staging, staging3): Email notifications (high urgency, 10 min delay)
resource "pagerduty_user_notification_rule" "staging_email" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "staging" || var.environment == "staging3") && local.user_contact_method_ids[k].email != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 10
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].email
    type = "email_contact_method"
  }
}

# Staging (staging, staging3): Teams notifications (high urgency, 1 min delay for visibility)
resource "pagerduty_user_notification_rule" "staging_teams" {
  for_each = { for k, v in var.users : k => v 
    if (var.environment == "staging" || var.environment == "staging3") && local.user_contact_method_ids[k].teams != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 1
  urgency                = "high"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].teams
    type = "teams_contact_method"
  }
}

# Non-Production (dev, test, sandbox): Email notifications (low urgency, immediate)
resource "pagerduty_user_notification_rule" "nonprod_email" {
  for_each = { for k, v in var.users : k => v 
    if (!(var.environment == "prod" || var.environment == "prod3" || var.environment == "staging" || var.environment == "staging3")) && local.user_contact_method_ids[k].email != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 0
  urgency                = "low"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].email
    type = "email_contact_method"
  }
}

# Non-Production (dev, test, sandbox): Teams notifications (low urgency, 1 min delay)
resource "pagerduty_user_notification_rule" "nonprod_teams" {
  for_each = { for k, v in var.users : k => v 
    if (!(var.environment == "prod" || var.environment == "prod3" || var.environment == "staging" || var.environment == "staging3")) && local.user_contact_method_ids[k].teams != null 
  }
  user_id                = each.value.id
  start_delay_in_minutes = 1
  urgency                = "low"
  contact_method = {
    id   = local.user_contact_method_ids[each.key].teams
    type = "teams_contact_method"
  }
}
