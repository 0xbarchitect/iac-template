# Kubernestes cluster
Detail instruction on how to setup K8S cluster.

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
* [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* [Istioctl v1.21+](https://istio.io/latest/docs/setup/install/istioctl/)
* [Helm v3.8+](https://helm.sh/docs/intro/install/)
* [AWScurl](https://github.com/okigan/awscurl)
* [EKS cluster](../eks/README.md)

## Create namespace
```bash
$ kubectl apply -f namespace.yaml
```

## Configure Container-registry pull secret
* Prerequisites

You must login to gitlab registry first

```bash
$ docker login registry.gitlab.com
```

(**!Important**) You need to delete credStore in *.docker/config.json* (because pull secret will create from config.json file, hence credentials auth data must write into config file instead of store in machine)

* Create pull secret from docker config local
```bash
$ kubectl create secret generic <pull-secret-name> --from-file=.dockerconfigjson=<path-to-docker-folder>/config.json --type=kubernetes.io/dockerconfigjson -n <namespace>
```

* Config image pull secret for default service account
```bash
$ kubectl patch sa default -n <namespace> -p '"imagePullSecrets": [{"name": "<pull-secret-name>" }]'
```

* Verify configuration
```bash
$ kubectl edit sa default -n <namespace> # check imagePullSecrets configuration
```

> **IMPORTANT:** Need create imagePullSecret for all namespace, including prod, pre-prod, default.

## Setup [ALB controller for Ingress](./alb/README.md)

## (Optional, after install *Istio*) [Self-managed Redis cluster](./redis/README.md)

## Setup [K8S dashboard](./k8s-dashboard/README.md)

## Cleanup
* Cleanup [ALB controller for Ingress](./alb/README.md#cleanup)
* Cleanup (optional) [Self-managed Redis cluster](./redis/README.md#cleanup)

```bash
$ kubectl delete -f namespace.yaml
```