# Postgres client
The Postgresql client to connect with the DB cluster using Cloud SQL proxy

## Setup

- Create a service account for Cloud SQL proxy with role `CloudSQL client` in `GCP console > IAM & Admin > Service Accounts`.

- Create a private key in `Service account detail > Key` with type JSON.

- Download the key JSON file to the local computer and save it as `sa-secrets.json`

- Create k8s secret from the key JSON file
```sh
$ kubectl create secret generic cloudsql-credentials --from-file=service_account.json=sa-secrets.json
```

- Install Helm chart
```sh
$ helm upgrade -i pg-client ./pg-client
```