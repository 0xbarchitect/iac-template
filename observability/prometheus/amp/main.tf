terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"      
    }
  }
}

provider "aws" {
  # retrieve from env vars
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_prometheus_workspace" "k8s-cluster" {
  alias = "k8s-cluster"

  tags = {
    Environment = "production"
  }
}