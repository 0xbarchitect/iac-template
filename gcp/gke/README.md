## GKS configuration
The installation guide for GKS clusters.

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