# ALB Controller for EKS Ingress
Detail instruction on how to setup ALB controller for Ingress

## Prerequisites
* [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* [Helm v3.8+](https://helm.sh/docs/intro/install/)

## Retrieve EKS cluster name

```sh
$ cd ../eks
$ terraform output cluster_name
```

## Configure IAM policy

* Create IAM policy for cluster service account, which allow node to create / config ALB

```sh
$ aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

* Create IAM role for service account (IRSA)

```sh
$ eksctl create iamserviceaccount \
    --cluster=<cluster-name> \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region <region-code> \
    --approve
```

* Verify IRSA is created properly

```sh
$ kubectl get sa aws-load-balancer-controller -n kube-system
```

the service account "aws-load-balancer-controller" should be displayed in list


## Install ALB controller to EKS cluster

* Install Helm release

```sh
$ helm repo add eks https://aws.github.io/eks-charts
$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
    --set clusterName=<cluster-name> \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller
```

* Verify installation

```sh
$ kubectl get deploy aws-load-balancer-controller -n kube-system
```

the ALB controller should be up and running.

## Cleanup

```sh
$ helm uninstall aws-load-balancer-controller -n kube-system
```
