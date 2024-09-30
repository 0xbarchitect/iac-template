output "bucket_arn" {
  value = aws_s3_bucket.default.arn
  description = "Bucket ARN"
}

output "bucket_domain" {
  value = aws_s3_bucket.default.bucket_domain_name
  description = "Bucket domain"
}