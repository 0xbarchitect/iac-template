provider "google" {
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

resource "google_compute_address" "static" {
  count  = var.instance_number
  name   = "${var.cluster_name}-static-ip-${count.index}"
  region = var.GOOGLE_REGION
}

resource "google_compute_instance" "default" {
  count        = var.instance_number
  name         = "${var.cluster_name}-${count.index}"
  machine_type = var.instance_type
  zone         = var.GOOGLE_ZONE

  tags = ["validator-nodes-firewall"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 2048
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static[count.index].address
    }
  }
}

# resource "google_compute_firewall" "default" {
#   name    = "validator-nodes-firewall"
#   network = "default"

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "9651"]
#   }

#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["validator-nodes-firewall"]
# }