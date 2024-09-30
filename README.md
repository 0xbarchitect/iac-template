# All-in-one IaC template
The universal Infra-as-Code (IaC) template for microservice systems that includes CICD pipelines, AWS cloud and on-prem resources management.

## Architecture

The high-level architecture of the system
- [System diagram](./docs/system-architecture.md)

Main components:
- EKS K8S cluster
- Istio service mesh
- Application load balancer ALB, Istio ingress-gateway
- Databases service: RDS Aurora, S3, OpenSearch (ELK), Redis (ElasticCache)
- Cloudflare CDN
- Observability stack: ELK (Logs), Prometheus (Metrics), Jaeger (Tracing)

## Prerequisites

- [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
- [Kubectl v1.29+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [Istioctl v1.21+](https://istio.io/latest/docs/setup/install/istioctl/)
- [Helm v3.8+](https://helm.sh/docs/intro/install/)
- [AWScurl](https://github.com/okigan/awscurl)

## Setup

Installation steps in order:

- [IAM policy](./iam/README.md)
- [EKS cluster](./eks/README.md)
- [K8S cluster](./k8s/README.md)
- [Jenkins CICD](./jenkins/README.md)
- [Istio service mesh](./istio/README.md)
- [RDS Aurora Postgres](./rds/README.md)
- [ElastiCache Redis](./elasticache/README.md)
- [S3 bucket](./s3/README.md)
- [SQS queues](./sqs/README.md)
- [Observability](./observability/README.md)

## Cleanup

- Delete all service charts in prod namespaces

```bash
$ helm delete <service-name> -n prod
```

- Cleanup [Istio service mesh](./istio/README.md#cleanup)
- Cleanup [K8S cluster](./k8s/README.md#cleanup)
- Cleanup [EKS cluster](./eks/README.md#cleanup)
- Cleanup [ElastiCache Redis](./elasticache/README.md#cleanup)
- Cleanup [S3 bucket](./s3/README.md#cleanup)
- Cleanup [SQS queues](./sqs/README.md#cleanup)
- Cleanup [RDS Aurora Postgres](./rds/README.md#cleanup)