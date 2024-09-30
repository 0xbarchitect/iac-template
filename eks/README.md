# Elastic Kubernetes Service
Detail instruction on how to provision EKS cluster on AWS.

## Prerequisites
- [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
- [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [IAM account with access credentials](https://console.aws.amazon.com)
- [Terraform-cloud registered account](https://app.terraform.io/app/darenft/workspaces)

## Configure AWS provider
- Create auto variables file from template
```bash
$ cp env.auto.tfvars.example env.auto.tfvars
```

- Fulfill AWS access credentials to env.auto.tfvars file

## Initialization
- Login to Terraform cloud with your registered account (skip this step if you have already logged in)
```bash
$ terraform login
```

- Init Terraform working directory
```bash
$ terraform init
```

## Configure Terraform-cloud workspace
- Create new workspace (skip this step if you just want to use provisioned cluster) 
>   Login to [Terraform-Cloud](https://app.terraform.io/) > Projects & workspaces > New Workspace, select CLI-driven workflow type, populate Workspace name


- List all available workspace (skip this step if you create new workspace)
```bash
$ terraform workspace list
```

- Select workspace for local environment
```bash
$ terraform workspace select <workspace-name>
```

## Create EKS cluster (skip this step if you want to use provisioned cluster)
- Review changes
```bash
$ terraform plan
```

- Apply changes
```bash
$ terraform apply -auto-approve
```

>   *Add argument -auto-approve for yes enforce*

## Connect to cluster
- List EKS cluster
```bash
$ AWS_PROFILE=<profile> aws eks list-clusters \
--region <region>
```

Authorize AWS user to connect to cluster by adding IAM identity to the aws-auth ConfigMap, this action must be completed by creator of cluster

- Get current IAM identity (target user do this)

```bash
$ aws sts get-caller-identity
```

- Add IAM identity to aws-auth ConfigMap (creator do this)
```bash
$ eksctl create iamidentitymapping \
--cluster <cluster-name> \
--region <region> \
--arn <arn-get-from-above> \
--group system:masters \
--no-duplicate-arns \
--username <username>
```

- Add cluster to kubeconfig (target user do this)
```bash
$ AWS_PROFILE=<profile> aws eks update-kubeconfig \
--region $(terraform output -raw region) \
--name $(terraform output -raw cluster_name)
```

- Verify cluster
```bash
$ kubectl config get-contexts
$ kubectl cluster-info
```

then

```bash
$ kubectl get nodes
```

## Cleanup 
* Delete EKS cluster
```bash
$ terraform destroy
```

* Delete all local terraform files
```bash
$ rm -rf .terraform/
$ rm -f .terraform.lock.hcl
```