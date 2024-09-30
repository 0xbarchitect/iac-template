# Redis Elasticache
Detail instruction on how to setup Redis Elasticache cluster on AWS.

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
* [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* [Istioctl v1.19+](https://istio.io/latest/docs/setup/install/istioctl/)
* [Helm v3.8+](https://helm.sh/docs/intro/install/)
* [AWScurl](https://github.com/okigan/awscurl)

## Configure AWS provider

- Create auto variables file from template

```sh
$ cp env.auto.tfvars.example env.auto.tfvars
```
then populate AWS access credentials to `env.auto.tfvars` file

## Initialization

- Login to Terraform cloud with your registered account (skip this step if you have already logged in)

```sh
$ terraform login
```

- Init Terraform working directory

```sh
$ terraform init
```

## Configure Terraform-cloud workspace

- Create new workspace (skip this step if you just want to use provisioned cluster)
Login to [Terraform-Cloud](https://app.terraform.io/) > Projects & workspaces > New Workspace, select CLI-driven workflow type, populate Workspace name.

- List all available workspace (skip this step if you create new workspace)

```sh
$ terraform workspace list
```

- Select workspace for local environment

```sh
$ terraform workspace select <workspace-name>
```

## Create Elasticache cluster

- Review changes

```sh
$ terraform plan
```

- Apply changes

```sh
$ terraform apply
```

*Add argument -auto-approve for yes enforce*

## Verify connection

>   - Retrieve cluster endpoint

```sh
$ terraform output endpoint
```

>   - Spin up debug pod

```sh
$ kubectl run -it redis-cli --image=madflojo/redis-tls --restart=Never --rm -- sh
$ redis-cli --tls -h <cluster-endpoint> -a <auth-token>
```
Try to PING, PONG is expected to receive.

>   - Cleanup the debug pod
```sh
$ kubectl delete pod redis-cli
```

## Destroy cluster

- Delete EKS cluster

```sh
$ terraform destroy
```

## Cleanup 

- Delete all local terraform files

```sh
$ rm -rf .terraform/
$ rm -f .terraform.lock.hcl
```