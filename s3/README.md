# AWS S3
Detail instruction on how to setup S3 bucket.

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
* [IAM account with access credentials](https://console.aws.amazon.com)

## Configure AWS provider

* Create auto variables file from template

```sh
$ cp env.auto.tfvars.example env.auto.tfvars
```

then populate AWS access credentials to `env.auto.tfvars` file

* **IMPORTANT** The BUCKET_NAME value must be in format of DNS, eg. *static.public.domain*, in order to enable CDN on Cloudflare.

## Initialization

* Login to Terraform cloud with your registered account (skip this step if you have already logged in)

```sh
$ terraform login
```

* Init Terraform working directory

```sh
$ terraform init
```

## Configure Terraform-cloud workspace

* Create new workspace (only once)
>   Login to [Terraform-Cloud](https://app.terraform.io/) > Projects & workspaces > New Workspace, select CLI-driven workflow type, populate Workspace name.

* List all available workspace (skip this step if you create new workspace)

```sh
$ terraform workspace list
```

* Select workspace for local environment

```sh
$ terraform workspace select <workspace-name>
```

## Create S3 bucket

* Review changes

```sh
$ terraform plan
```

* Apply changes

```sh
$ terraform apply -auto-approve
```

*Add argument -auto-approve for yes enforce*

* If you encounter 403 error on creating bucket policy, just simply apply again to resolve it.

## Configure CDN on Cloudflare

* Upon creating the S3 bucket, assuming named *static.public.domain*, add DNS record in Cloudflare console with attributes:
> - Type: CNAME
> - Name: prefix of domain, eg. `static`
> - Target: <bucket-name>.s3.<region>.amazonaws.com, eg. `static.public.domain.s3.us-east-1.amazonaws.com`
> - Proxy: Enabled

## Cleanup

* Delete bucket

```sh
$ terraform destroy
```

* Delete all local terraform files

```sh
$ rm -rf .terraform/
$ rm -f .terraform.lock.hcl
```