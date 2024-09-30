# AWS Managed Prometheus
Terraform IaC for provisioning AWS Managed Prometheus service

## 1. Create workspace on Terraform cloud
Go to Terraform cloud > Project & workspaces > Create new workspace with CLI-driven workflow, set workspace name in to remote-state.tf file

```groovy
terraform {
  cloud {
    organization = "<org-name>"

    workspaces {
      name = "<workspace-name>"
    }
  }
}
```

## 2. Init

- Init project to install dependencies, load state, etc

```sh
$ terraform init
```

## 3. Load AWS credentials

- Create auto-tfvars file

```sh
$ cp env.auto.tfvars.example env.auto.tfvars
```

then populate values of AWS credentials in `env.auto.tfvars`

## 4. Plan

- Planning changes

```sh
$ terraform plan
```

## 5. Apply

- Apply changes to cloud

```sh
$ terraform apply
```

## 6. Destroy

- Destroy cloud resources

```sh
$ terraform destroy
```