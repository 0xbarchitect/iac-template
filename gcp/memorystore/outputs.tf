output "name" {
  description = "The name for Cloud Memorystore instance"
  value       = google_redis_instance.tf_redis_instance.name
}