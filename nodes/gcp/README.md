## GKS configuration
The installation guide for GKS clusters of validator nodes

## Setup 

- Create `env.auto.tfvars` from template and populate necessary secrets
```sh
$ cp env.auto.tfvars.example env.auto.tfvars`
```

- Create a Terraform with the name prefixed by `nodes-`, i.e. `nodes-testnet`

- Add `GOOGLE_CREDENTIALS` variable to Terraform workspaces, with the value retrieved from the command.
```sh
$ cat ./terraform-key.json | tr -s '\n' ' '
```

*Note: the variable MUST be marked as sensitive*

## Run

- Init
```sh
$ terraform init
```

- Plan
```sh
$ terraform plan
```

- Apply
```sh
$ terraform apply
```

## Kubectl

- (Optional) Install `google-cloud-cli-gke-gcloud-auth-plugin`
```sh
$ apt-get install google-cloud-cli-gke-gcloud-auth-plugin
```

- Add kube-config
```sh
$ gcloud container clusters get-credentials <cluster-name> --region <region> --project <PROJECT_ID>
```

- Verify access
```sh
$ kubectl get nodes
```

## Destroy

- Destroy
```sh
$ terraform destroy
```