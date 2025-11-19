################################
# Apps Service Configuration   #
################################

resource "pagerduty_service" "apps" {
  name                    = format("%s-%s", local.name_prefix, "apps")
  escalation_policy       = pagerduty_escalation_policy.apps.id
  acknowledgement_timeout = "null"
  auto_resolve_timeout    = "null"

  incident_urgency_rule {
    type    = "constant"
    urgency = (local.environment == "prod" || local.environment == "prod3") ? "severity_based" : "low"
  }
}

resource "pagerduty_service_integration" "apps" {
  name    = "Azure Alerts"
  vendor  = data.pagerduty_vendor.azure.id
  service = pagerduty_service.apps.id
}

resource "pagerduty_escalation_policy" "apps" {
  name      = format("%s-%s", local.name_prefix, "apps")
  num_loops = 1

  depends_on = [pagerduty_schedule.apps]

  rule {
    escalation_delay_in_minutes = (local.environment == "prod" || local.environment == "prod3") ? 30 : 60

    target {
      id   = pagerduty_schedule.apps.id
      type = "schedule_reference"
    }
  }
}

resource "pagerduty_schedule" "apps" {
  name      = format("%s-%s", local.name_prefix, "apps")
  teams     = []
  time_zone = "America/Chicago"

  layer {
    name                         = "Layer 1"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2025-01-01T07:00:00-06:00"
    start                        = "2025-01-01T07:00:00-06:00"
    users = [
      local.pagerduty_users["jlight@korioclinical.com"].id,
      local.pagerduty_users["lgadallah@korioclinical.com"].id
    ]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "07:00:00"
      duration_seconds  = 43200
    }
  }

  layer {
    name                         = "Layer 2"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2025-01-01T19:00:00-06:00"
    start                        = "2025-01-01T19:00:00-06:00"
    users = [
      local.pagerduty_users["jlight@korioclinical.com"].id,
      local.pagerduty_users["lgadallah@korioclinical.com"].id
    ]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "19:00:00"
      duration_seconds  = 43200
    }
  }
}
