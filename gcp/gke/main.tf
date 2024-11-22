provider "google" {
  #project     = "nft2-440103"
  #region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "gke-cluster-20241115"
  location = "us-central1"

  node_config {
    machine_type = "n1-standard-4"
  }

  initial_node_count = 4

  # Ensure deletion protection is set to false
  deletion_protection = false
}
     