provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "google_compute_instance" "default" {
  count        = 5
  name         = "instance-${count.index}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

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