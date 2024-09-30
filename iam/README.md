# IAM management
Manage IAM groups, users, policies.

## Create user groups
- Create user group in AWS console
```bash
$ <AWS_PROFILE=profile> aws iam create-group --group-name admin
$ <AWS_PROFILE=profile> aws iam create-group --group-name dev
```

- Verify created group
```bash
$ <AWS_PROFILE=profile> aws iam list-groups
```
the admin, dev groups should be exhibited in the returned list 

## Create IAM policy
- Create Admin policy using admin-permission.json
```bash
$ <AWS_PROFILE=profile> aws iam create-policy \
--policy-name AdminPolicy \
--policy-document file://admin-policy.json
```

- Create EKS policy
Create EKS admin policy using eks-admin-policy.json
```bash
$ <AWS_PROFILE=profile> aws iam create-policy \
--policy-name EKSAdminPolicy \
--policy-document file://eks-admin-policy.json
```

- Create Dev policy
Create Developer policy using dev-policy.json
```bash
$ <AWS_PROFILE=profile> aws iam create-policy \
--policy-name DevPolicy \
--policy-document file://dev-policy.json
```

- Verify policies are created properly
```bash
$ <AWS_PROFILE=profile> aws iam list-policies --scope Local
```

## Attach policies to user-groups
- Attach Admin policy to Admin group
```bash
$ <AWS_PROFILE=profile> aws iam attach-group-policy \
--group-name admin \
--policy-arn <admin-policy-arn>
```

- Attach Dev policies to Dev group
```bash
$ <AWS_PROFILE=profile> aws iam attach-group-policy \
--group-name dev \
--policy-arn <dev-policy-arn>
```
*the Policy ARN is retrieved from above step*

- Verify that policies are attached to corresponding groups properly
```bash
$ <AWS_PROFILE=profile> aws iam list-attached-group-policies --group-name <group-name>
```

## Update policy
- Update policy
```bash
$ aws iam create-policy-version \
--policy-arn <policy-arn> \
--policy-document file://<policy.json> \
--set-as-default
```

- Verify updated
```bash
$ aws iam get-policy-version \
--policy-arn <policy-arn> \
--version-id <version-id>
```
*version-id can be retrieved by create command above or get-policy command*

## Cleanup
- Delete group
```bash
$ aws iam delete-group \
--group-name <group-name>
```
