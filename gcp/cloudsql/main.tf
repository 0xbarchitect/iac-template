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

locals {
  read_replica_ip_configuration = {
    ipv4_enabled       = false
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    private_network    = data.google_compute_network.default.id
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.GOOGLE_PROJECT}-rep-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google
  name     = "${var.GOOGLE_PROJECT}-private-ip"
  purpose  = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

module "cloudsql_pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 22.0"

  name              = var.pg_ha_name
  project_id        = var.GOOGLE_PROJECT
  database_version  = "POSTGRES_14"
  random_instance_name = true

  // Master configurations
  tier                            = "db-custom-1-3840"
  zone                            = "us-central1-c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    env = "prod"
  }

  ip_configuration = {
    ipv4_enabled       = false
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    private_network    = data.google_compute_network.default.id
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.GOOGLE_PROJECT}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-slave-ha"
  read_replicas = [
    {
      name                  = "0"
      zone                  = "us-central1-a"
      availability_type     = "REGIONAL"
      tier                  = "db-custom-1-3840"
      ip_configuration      = local.read_replica_ip_configuration
      database_flags        = [{ name = "autovacuum", value = "off" }]
      disk_autoresize       = null
      disk_autoresize_limit = null
      disk_size             = null
      disk_type             = "PD_HDD"
      user_labels           = { env = "prod" }
      encryption_key_name   = null
    },
  ]

  db_name      = var.pg_dbname
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  user_name     = var.pg_user
  user_password = var.pg_password
}