# (DEPRECATED) Redis cluster
Instruction on how to setup internal Redis cluster in K8S cluster, this cluster is TEMPORARILY used for some services, which has not been migrated to TLS-supported Redis yet

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* [Istioctl v1.21+](https://istio.io/latest/docs/setup/install/istioctl/)
* [Helm v3.8+](https://helm.sh/docs/intro/install/)

## Installation

* Add Bitnami Helm repo

```sh
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm repo update
```

* Install Redis-cluster chart

```sh
$ helm install redis bitnami/redis -n istio-system
```

* Redis endpoint will be printed out in output, it should be redis-master.istio-system.svc.cluster.local

* Retrieve Redis password

```sh
$ kubectl get secret --namespace istio-system redis -o jsonpath="{.data.redis-password}" | base64 -d
```

* Connect to Redis

- Spin up debug pod

```sh
$ kubectl run -it redis-cli --image=goodsmileduck/redis-cli --restart=Never --rm -- sh
$ redis-cli -h <redis-endpoint> -a <redis-password>
```


- Try to PING, should receive PONG sucessfully.

- Cleanup

```sh
$ kubectl delete redis-cli
```

## Cleanup

```sh
$ helm uninstall redis -n istio-system
```






