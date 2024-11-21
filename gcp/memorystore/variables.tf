variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "GOOGLE_PROJECT" {
  type = string
}

variable "GOOGLE_REGION" {
  type = string
}

variable "redis_instance_name" {
  type        = string
  description = "The name for Cloud Memorystore instance"
  default     = "tf-redis"  
}

variable "redis_password" {
  type        = string
  description = "The password for Cloud Memorystore instance"
}