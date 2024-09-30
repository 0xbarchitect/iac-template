# FluentBit
The setup guide for FluentBit logs collector.

### CONFIGURE IAM POLICY FOR WORKER NODES
To enable FluentBit daemonset to export logs to CloudWatch, cluster nodes must be granted appropriate permissions.

* Get cluster name

```sh
$ export CLUSTER_NAME="$(eksctl get cluster | jq -r '.[].Name')"
```

* Get ROLENAME

```sh
$ ROLE_NAME=$(eksctl get nodegroup --cluster $CLUSTER_NAME -o json | jq -r '.[].NodeInstanceRoleARN')
```

* Grant Cloudwatch's permissions to cluster nodes role

```sh
$ aws iam put-role-policy --role-name $ROLE_NAME --policy-name Logs-Policy-For-Worker --policy-document file://iam-k8s-logs-policy.json
```

* Verify permission granted (or check in AWS console)

```sh
$ aws iam get-role-policy --role-name $ROLE_NAME --policy-name Logs-Policy-For-Worker
```