provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "postgres-master"
  engine = "aurora-postgresql"
  engine_version = "14"
  allow_major_version_upgrade = false
  
  master_username = "postgres"
  manage_master_user_password = true

  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.NUMBER_INSTANCE
  identifier         = "aurora-postgres-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = var.INSTANCE_TYPE
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
}
