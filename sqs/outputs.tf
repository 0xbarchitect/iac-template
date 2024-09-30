
output "app_queues_arn" {
    description = "ARN of queues"
    value = values(aws_sqs_queue.app_queues)[*].arn
}

output "app_dlq_arn" {
    description = "ARN of dead-letter queues"
    value = values(aws_sqs_queue.app_dlqs)[*].arn
}


