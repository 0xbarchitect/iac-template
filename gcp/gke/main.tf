provider "google" {
  project     = var.GOOGLE_PROJECT
  region      = var.GOOGLE_REGION
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-central1"

  node_config {
    machine_type = "n1-standard-4"
  }

  initial_node_count = 4

  # Ensure deletion protection is set to false
  deletion_protection = false
}
     