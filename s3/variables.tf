variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "BUCKET_NAME" {
  type = string
  description = "The name of bucket"
}

variable "CORS_ALLOWED_ORIGINS" {
  type = list(string)
  description = "The list of supported domains, from where will be able to upload file"
}

