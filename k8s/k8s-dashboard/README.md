# K8S Dashboard
Detail instruction on how to setup K8S dashboard, the administration console for cluster.

## Setup

* Install Helm chart

```sh
$ helm install k8s-dashboard . -n kube-system
```

* Verify status

```sh
$ helm status k8s-dashboard -n kube-system
$ kubectl get deploy kubernetes-dashboard -n kube-system
```

* Accessing dashboard

Spin up K8S proxy

```sh
$ kubectl proxy
```

You can access dashboard at [Dashboard endpoint](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/)

* Create access token

```sh
$ kubectl create token admin-user -n kube-system
```

then use the generated access token to login to Dashboard

## Cleanup

* Uninstall Helm chart

```sh
$ helm uninstall k8s-dashboard -n kube-system
```