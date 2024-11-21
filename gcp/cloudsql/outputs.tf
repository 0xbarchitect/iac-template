output "project_id" {
  value = var.GOOGLE_PROJECT
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.cloudsql_pg.instance_name
}

output "authorized_network" {
  value = var.pg_ha_external_ip_range
}

output "replicas" {
  value = module.cloudsql_pg.replicas
  sensitive = true
}

output "instances" {
  value = module.cloudsql_pg.instances
  sensitive = true
}