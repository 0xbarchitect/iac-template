# ELK
The setup guide for ELK centralized logs store.

## Create Lambda Role to stream CWL to ES

```sh
$ aws iam create-role --role-name <ROLE_NAME> --assume-policy-document file://lambda.json
$ aws iam create-policy --policy-name <POLICY_NAME> --policy-document file://lambda_es_policy.json
$ aws iam attach-role-policy --role-name <ROLE_NAME> --policy-arn <POLICY_ARN>
$ aws iam attach-role-policy --role-name <ROLE_NAME> --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole
$ aws iam attach-role-policy --role-name <ROLE_NAME> --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
$ aws iam list-attached-role-policies --role-name <ROLE_NAME>
```