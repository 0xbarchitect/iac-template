# GCP configuration
The installation guide for GCP infrastructures.

## Prerequisites

- [Gcloud](https://cloud.google.com/sdk/docs/install#deb)

## Setup

- Initialize gcloud
```sh
$ gcloud auth login
```

- Config project
```sh
$ gcloud config set project <PROJECT_ID>
```

- Create a Service account for Terraform
```sh
$ gcloud iam service-accounts create terraform --display-name "Terraform admin account"
```

- Assign roles to the service account
```sh
$ gcloud projects add-iam-policy-binding <PROJECT_ID> --member "serviceAccount:terraform@<PROJECT_ID>.iam.gserviceaccount.com" --role "roles/owner"
```

- Generate a key file for the service account
```sh
$ gcloud iam service-accounts keys create ./terraform-key.json --iam-account terraform@<PROJECT_ID>.iam.gserviceaccount.com
```

- Create a Terraform cloud workspace, e.g. `gks-20241125`

- Add an workspace variable named `GOOGLE_CREDENTIALS` to the workspace, with the value retrieved from the command.
```sh
$ cat ./terraform-key.json | tr -s '\n' ' '
```

*Note: the variable MUST be marked as sensitive*

For more information, please refer to [instruction on Terraform docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started)

## Run
Please refer to corresponding modules for instruction details.

- [GKE](./gke/README.md)
- [Istio](./istio/README.md)
- [CloudSQL](./cloudsql/README.md)
- [Memorystore Redis](./memorystore/README.md)