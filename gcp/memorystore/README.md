# MemoryStore, aka Managed Redis service
The installation guide for managed Redis service

## Setup

- Enable the Memorystore service in the GCP console.

- Create `env.auto.tfvars` from template and populate necessary credentials
```sh
$ cp env.auto.tfvars.example env.auto.tfvars
```

- Create Terraform cloud workspace with prefix `gcp-memstore-`, e.g. `gcp-memstore-20241115`

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
$ terraform apply -auto-approve
```

## Connect

- Find the auth string in `GCP console > Memorystore for Redis > Instance detail > Security > Auth string`

- Run a debug pod using `redis` docker image
```sh
$ kubectl run -it redis-cli --image=redis --restart=Never --rm -- sh
$ redis-cli -h <REDIS_HOST> -a <AUTH_STRING>
```

*Note: the `REDIS_HOST` can be found in instance detail page in GCP console*

## Clean

- Destroy
```sh
$ terraform destroy
```