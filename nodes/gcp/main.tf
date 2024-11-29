provider "google" {
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

resource "google_compute_instance" "default" {
  count        = var.instance_number
  name         = "${var.cluster_name}-${count.index}"
  machine_type = var.instance_type
  zone = var.GOOGLE_ZONE

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}