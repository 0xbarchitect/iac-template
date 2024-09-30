# Prometheus monitoring for K8S cluster

Architecture
* Prometheus agent installed in cluster
* Agent remote-write to AWS managed Prometheus

## 1. Add prometheus helm charts repo

```sh
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo update
```

## 2. Create IAM role for K8S service account

```sh
$ ./createIRSA-AMPIngest.sh
```

## 3. Provision AWS managed Prometheus
Please follow [guidance](./amp/README.md)  to provision AMP workspace

## 4. Set values for helm charts

- Fulfill values with IAM roles, service account and AMP endpoint in `./amp_ingest_values.yaml`

```yaml
serviceAccounts:
  server:
    name: "<service-account-name>"
    annotations:
      eks.amazonaws.com/role-arn: "<iam-role-arn>"
server:
  remoteWrite:
    - url: "<amp-remote-write-endpoint-url>"
      sigv4:
        region: "<aws-region>"
      queue_config:
        max_samples_per_send: 1000
        max_shards: 200
        capacity: 2500
```

## 5. Install (upgrade) helm chart

```sh
$ helm install prometheus-for-amp prometheus-community/prometheus -f ./amp_ingest_values.yaml -n istio-system
```

## 6. Verify installation

```sh
$ helm ls --all-namespaces
$ kubectl get svc prometheus-for-amp-server -n istio-system
```

## 7. Uninstall
```sh
$ helm uninstall prometheus-for-amp -n istio-system
```