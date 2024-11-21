variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "GOOGLE_PROJECT" {
  type = string
}

variable "GOOGLE_REGION" {
  type = string
}

variable "pg_ha_name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-ha"
}

variable "pg_ha_external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}

variable "pg_dbname" {
  type        = string
  description = "The name of the primary database"
  default     = "nft2"
}

variable "pg_user" {
  type        = string
  description = "The name of the root user" 
}

variable "pg_password" {
  type        = string
  description = "The password of the root user"
}

