# CloudSQL cluster
Installation guide for PostgreSQL cluster on GCP.

## Setup

- Enable the CloudSQL service in the GCP console.

- Create `env.auto.tfvars` from template and populate necessary credentials
```sh
$ cp env.auto.tfvars.example env.auto.tfvars
```

- Create Terraform cloud workspace with prefix `gcpsql-`, e.g. `gcpsql-20241115`

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

- Create a service account for Cloud SQL proxy with role `CloudSQL client` in `GCP console > IAM & Admin > Service Accounts`.

- Create a private key in `Service account detail > Key` with type JSON.

- Download the key JSON file to the local computer and save it as `sa-secrets.json`

- Create k8s secret from the key JSON file
```sh
$ kubectl create secret generic cloudsql-credentials --from-file=service_account.json=sa-secrets.json
```

- Populate the `instanceConnectionName` in the `./pg-client/values.yaml` with the value found on `GCP console > Cloud SQL > Instance detail > Overview > Connect to this instance`.

- Install Helm chart
```sh
$ helm upgrade -i pg-client ./pg-client
```

- Connect DB via proxy
```sh
$ kubectl exec -it <pod> -c pg-client -- sh
$ psql -h localhost -U <username> -d <dbname>
```

then input `password` to connect to DB.

*Note: the `username`, `dbname`, `password` is specified in Terraform main.tf files*

## Clean

- Delete all databases
```sh
$ drop database <dbname>;
```

- Destroy
```sh
$ terraform destroy
```