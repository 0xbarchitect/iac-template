provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

locals {
  cluster_name = "elasticache-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name        = "elasticache-subnet-${random_string.suffix.result}"
  description = "elasticache for main services"
  subnet_ids  = var.SUBNET_IDS
}

resource "aws_security_group" "allow_redis" {
  name   = "allow-redis-${random_string.suffix.result}"
  vpc_id = var.VPC_ID

  ingress {
    from_port   = var.REDIS_PORT
    to_port     = var.REDIS_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  description                = "elasticache for main services"
  replication_group_id       = "redis"
  num_cache_clusters         = 1 # single server mode
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet_group.name
  apply_immediately          = true
  maintenance_window         = "sun:05:00-sun:06:00"
  security_group_ids         = [aws_security_group.allow_redis.id]
  multi_az_enabled           = false
  automatic_failover_enabled = false
  engine                     = "redis"
  engine_version             = "7.0"
  parameter_group_name       = "default.redis7"
  port                       = var.REDIS_PORT
  node_type                  = "cache.m4.large"
  transit_encryption_enabled = true # mandate to enable authentication
  auth_token                 = var.AUTH_TOKEN
}

