provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
}

data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.GOOGLE_REGION
}

resource "google_redis_instance" "tf_redis_instance" {
  name           = var.redis_instance_name
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  region         = var.GOOGLE_REGION
  location_id    = "us-central1-a"

  redis_version  = "REDIS_6_X"

  authorized_network = data.google_compute_network.default.id

  auth_enabled = true
}