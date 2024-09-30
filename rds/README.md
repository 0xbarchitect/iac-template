# RDS Postgres
Detail instruction on how to setup Postgres cluster on AWS, and setup connection with EKS cluster, enable pod to leverage DB instances.

## Prerequisites
- [AWS CLI v2.7+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Kubectl v1.24+](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [EKSctl v0.136+](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [K8S cluster](../k8s/README.md)

### Configure AWS provider

- Create auto variables file from template

```bash
$ cp env.auto.tfvars.example env.auto.tfvars
```

*Populate AWS access credentials to env.auto.tfvars file*

### Initialization

- Login to Terraform cloud with your registered account (skip this step if you have already logged in)

```bash
$ terraform login
```

- Init Terraform working directory

```bash
$ terraform init
```

### Configure Terraform-cloud workspace

- Create new workspace (only once) 
>   Login to [Terraform-Cloud](https://app.terraform.io/) > Projects & workspaces > New Workspace, select CLI-driven workflow type, populate Workspace name, e.g. s3-protocol


- List all available workspace (skip this step if you create new workspace)

```bash
$ terraform workspace list
```

- Select workspace for local environment

```bash
$ terraform workspace select <workspace-name>
```

### Create DB cluster

- Review changes

```bash
$ terraform plan
```

- Apply changes

```bash
$ terraform apply -auto-approve
```

- Lookup for root password in Secret Manager upon provisioning success.

## Inter-cluster connection between RDS and EKS

### Create connection (VPC peering)

- Create VPC peering connection from EKS VPC

```bash
$ aws ec2 create-vpc-peering-connection --vpc-id <EKS vpc id> --peer-vpc-id <RDS vpc id>
```

- Accept peering connection by RDS VPC

```bash
$ aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id <peering connection id from above>
```

- Create forward traffic from EKS to RDS via VPC-peering

```bash
$ aws ec2 create-route --route-table-id <EKS private route table id> --destination-cidr-block <RDS vpc cidr> --vpc-peering-connection-id <peering connection id from above>

$ aws ec2 create-route --route-table-id <EKS public route table id> --destination-cidr-block <RDS vpc cidr> --vpc-peering-connection-id <peering connection id from above>
```

- Create forward traffic from RDS to EKS via VPC-peering

```bash
$ aws ec2 create-route --route-table-id <RDS private route table id (if exist)> --destination-cidr-block <EKS vpc cidr> --vpc-peering-connection-id <peering connection id>

$ aws ec2 create-route --route-table-id <RDS public route table id (if exist)> --destination-cidr-block <EKS vpc cidr> --vpc-peering-connection-id <peering connection id>
```

- Create ingress security group rule (incoming traffic from EKS VPC to RDS) 

```bash
$ aws ec2 authorize-security-group-ingress --group-id <RDS security group> --protocol tcp --port 5432 --cidr <EKS vpc cidr>
```

upon setup VPC peering between RDS and EKS, the connection can be verified following procedure.

### Create external-name service in EKS cluster

* Replace RDS endpoint to field `externalName` in file `k8s-postgres-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: postgres-service
  name: postgres-service
spec:
  externalName: <RDS-Endpoint>
  selector:
    app: postgres-service
  type: ExternalName
status:
  loadBalancer: {}
```

- Create service

```bash
$ kubectl apply -f ./k8s-postgres-service.yaml
```

### Verify connection

- Spin up debug pod

```bash
$ kubectl run -it psql-cli --image=jbergknoff/postgresql-client --restart=Never --rm --command -- sh
$ psql -h postgres-service.default -U <db_user> -d <db_name>
```
Input db password and should be access to DB successfully.

- Clean up debug pod (in case it is not terminated automatically)

```bash
$ kubectl delete pod psql-cli
```

## Utils

- Create DB and user for service
In case need to create DB and user for new service workload, use following SQL script (refer to postgres.sql for detail)

```sql
create database <db_name>;
revoke all on database <db_name> from public;
create role <db_role>;
grant connect on database <db_name> to <db_role>;
create user <db_user> with password '<secret>';
grant <db_role> to <db_user>;
```

## Cleanup

- Delete DB instance

```bash
$ terraform destroy
```

- Delete all local terraform files

```bash
$ rm -rf .terraform/
$ rm -f .terraform.lock.hcl
```

- Delete k8s external-name service

```bash
$ kubectl delete -f ./k8s-postgres-service.yaml
```