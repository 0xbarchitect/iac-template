# AWS credentials
variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "INSTANCE_TYPE" {
  type = string
  default = "db.t3.medium"
}

variable "NUMBER_INSTANCE" {
  type = number
  default = 2
}



