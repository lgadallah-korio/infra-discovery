provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

provider "pagerduty" {
  token = var.pagerduty_token
}

provider "http" {
  alias = "pagerduty"
}
