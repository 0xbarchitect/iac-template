# AWS SQS
Detail instruction on how to setup SQS queues

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
* [IAM account with access credentials](https://console.aws.amazon.com)

## Configure AWS provider
* Create auto variables file from template
```bash
$ cp env.auto.tfvars.example env.auto.tfvars
```

* Populate AWS access credentials to env.auto.tfvars file

## Initialization
* Login to Terraform cloud with your registered account (skip this step if you have already logged in)
```bash
$ terraform login
```

* Init Terraform working directory
```bash
$ terraform init
```

## Configure Terraform-cloud workspace
* Create new workspace (only once) 
```
Login to [Terraform-Cloud](https://app.terraform.io/) > Projects & workspaces > New Workspace, select CLI-driven workflow type, populate Workspace name, e.g. sqs-protocol
```

* List all available workspace (skip this step if you create new workspace)
```bash
$ terraform workspace list
```

* Select workspace for local environment
```bash
$ terraform workspace select <workspace-name>
```
* Show current state
```bash
$ terraform show
```

## Create SQS queues
* Review changes
```bash
$ terraform plan
```

* Apply changes
```bash
$ terraform apply -auto-approve
```

*Add argument -auto-approve for yes enforce*

## Cleanup
* Delete queues
```bash
$ terraform destroy
```
* Delete all local terraform files
```bash
$ rm -rf .terraform/
$ rm -f .terraform.lock.hcl
```