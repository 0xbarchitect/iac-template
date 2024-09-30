output "db_arn" {
  description = "DB instance ARN"
  value = aws_rds_cluster.default.arn
}

output "db_endpoint" {
  description = "DB instance endpoint"
  value = aws_rds_cluster.default.endpoint
}

output "db_port" {
  description = "DB instance port"
  value = aws_rds_cluster.default.port
}

output "db_engine" {
  description = "DB instance engine"
  value = aws_rds_cluster.default.engine
}

output "db_engine_version" {
  description = "DB instance engine version"
  value = aws_rds_cluster.default.engine_version
}

output "db_master_username" {
  description = "DB instance master username"
  value = aws_rds_cluster.default.master_username
}

output "db_master_user_secret" {
  description = "DB instance master user secret"
  value = aws_rds_cluster.default.master_user_secret
}
