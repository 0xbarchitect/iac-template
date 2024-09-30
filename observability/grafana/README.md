# Grafana

Architecture:
* Grafana installed in K8S cluster
* AWS managed Prometheus datasource

## 1. Add prometheus helm charts repo

```sh
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
```

## 2. Create IAM role for K8S service account

Refer to Prometheus provisioning for creating IAM role for K8s service account

## 3. Set values for helm charts

- Fulfill values with IAM roles, service account in `./amp_query_values.yaml`

```yaml
serviceAccount:
  name: "<service-account-name>"
  annotations:
    eks.amazonaws.com/role-arn: "<iam-role-arn>"
```

## 4. Install (upgrade) helm chart

```sh
$ helm install grafana-for-amp grafana/grafana -f ./amp_query_values.yaml -n istio-system
```

## 5. Verify installation

```sh
$ helm ls --all-namespaces
$ kubectl get svc grafana-for-amp -n istio-system
```

## 6. Add AMP datasource

- Proxy grafana service to local

```sh
$ kubectl port-forward service/grafana-for-amp :80 -n istio-system
```

Open Grafana > Connections > Data sources > Add new data source > Select Prometheus

* HTTP URL get from AMP console (query endpoint without suffix /api/v1/query)

* SigV4 auth with Default region corresponds to your aws region
Save & Test to ensure connection succeed

## 7. Import dashboard

* Get datasource ID from previous step, replace it to `/dashboards/k8s_cluster_monitor.json` file

* Open Grafana > Dashboards > New > Import > Upload dashboard JSON file

## 8. Uninstall

```sh
$ helm uninstall grafana-for-amp -n istio-system
```