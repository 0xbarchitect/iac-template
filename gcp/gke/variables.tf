variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "GOOGLE_PROJECT" {
  type = string
}

variable "GOOGLE_REGION" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"  
}
