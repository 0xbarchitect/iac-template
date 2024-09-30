variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "ENGINE" {
  type        = string
  default     = ""
  description = "The name of the cache engine to be used for the clusters in this replication group. e.g. redis."
}

variable "AUTH_TOKEN" {
  type        = string
  default     = ""
  description = "Redis Auth"
}

variable "VPC_ID" {
  type        = string
  default     = ""
  description = "VPC id of EKS"
}

variable "SUBNET_IDS" {
  type        = list(string)
  default     = [""]
  description = "Subnet ids of VPC of EKS"
}

variable "REDIS_PORT" {
  type        = number
  default     = 6379
  description = "Redis port number"
}
