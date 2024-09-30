# IAM credentials
variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

# SQS queues
variable "app_queues" {
  description = "SQS queues"
  type        = list(string)
  default     = ["app1_queue", "app2_queue", "app3_queue"]
}

variable "app_dlq" {
  description = "SQS Dead-letter-queue"
  type        = list(string)
  default     = ["app_dlq"]
}

variable "supported_envs" {
  type = list(string)
  description = "Supported environments: stage, pre, prod"
  default = [ "stage", "pre", "prod" ]
}

