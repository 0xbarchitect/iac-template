# AWS resources provisioning
# Included SQS, S3, DynamoDB, etc

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

locals {
  app_queues = [ for val in setproduct(var.app_queues, var.supported_envs) : {
    name = "${val[0]}_${val[1]}"
    idx = val[1] == "pre" ? 0 : val[1] == "prod" ? 1 : 2 # lexicographical order pre -> prod -> stage
    tag = val[1]
  }]
  app_dlq_queues = [ for val in setproduct(var.app_dlq, var.supported_envs) : {
    name = "${val[0]}_${val[1]}"
    tag = val[1]
  }]
}

resource "aws_sqs_queue" "app_dlqs" {
  for_each = { for config in local.app_dlq_queues: config.name => config }
  name = each.value.name
  tags = {
    env = each.value.tag
  }
}

resource "aws_sqs_queue" "app_queues" {
  for_each = { for config in local.app_queues: config.name => config }
  name = each.value.name
  redrive_policy = jsonencode({
    deadLetterTargetArn = values(aws_sqs_queue.app_dlqs)[each.value.idx].arn
    maxReceiveCount     = 5
  })
  tags = {
    env = each.value.tag
  }
}
