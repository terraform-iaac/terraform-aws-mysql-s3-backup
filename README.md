# Backup MySQL database form RDS instance

Terraform module for backup MySQL database from RDS instance to s3 bucket. 

## Wokrflow

Module create s3 bucket as backup storage, lambda function (type - container) with scheduled trigger event as CloudWatch event, VPC endpoint for s3 data transfer 
and some IAM policies for access to RDS instance, KMS keys and s3 bucket. Lambda will trig python script inside container which create .sql file from chosen 
database and locate it in s3 bucket.

## Software Requirements

Terraform >= v0.14.9

Python >= 3.8

## AWS Profile

Create an AWS account and get aws_access_key_id and aws_secret_access_key.
Follow [this instruction](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) from AWS to configure your AWS profile.

We recommend to use AWS profile (export AWS access and secret keys as environment variables), but you can setup keys by run command:

```aws configure```

## Init Step

### Docker

You can use pre-build image **iaac/aws-lamda-mysql-backup:latest** or build own image from *templates* folder.

To build backup image:

```sudo docker build -f templates/Dockerfile -t my-custom-organization/my-custom-repo:latest .```

After that you can push images to your private image repo:

```sudo docker push my-custom-organization/my-custom-repo:latest```

## Usage

```
module "database_backup" {
  source = "../"

  env           = "common"
  global_prefix = "project_name"
  region        = "us-west-1"

  vpc_id                 = "vpc-123456"
  route_table_ids        = ["rt-123456g"]
  vpc_security_group_ids = ["sg-123456g"]
  vpc_subnet_ids         = ["subnet-123456s"]

  cron_expression = "cron(0 5,8,11,14,17,20 * * ? *)"

  database_host = "rds.amazonaws.com"
  database_name = "test_db"
  database_pass = "secretpass"
  database_user = "test_user"

  # Image (optional if you build your own image)
  backup_image_repo = "my-custom-organization/my-custom-repo"
  backup_image_tag  = "v1.0.0"
}
```

## Inputs

Name | Description | Type | Default | Example | Required 
--- | --- | --- | --- |--- |--- 
env | Name of environment | `string` | n/a | `production` | yes 
global_prefix | Name of project / company/ customer | `string` | n/a | `test` | yes 
backup_image_repo | Image repository name | `string` | `iaac/aws-lamda-mysql-backup` | `organization/repo` | no 
backup_image_tag | Image tag version | `string` | `latest` | `v1.0` | no 
region | Name of AWS region | `string` | n/a | `us-west-1` | yes 
vpc_id | VPC where RDS instance deployed | `string` | n/a | `vpc-123456` | yes 
vpc_security_group_ids | IDs of VPC security group with access to RDS | `list(string)` | n/a | `sg-123456g` | yes 
vpc_subnet_ids | IDs of VPC subnets | `list(string)` | n/a | `subnet-123456s` | yes 
route_table_ids | IDs of route tables associated with VPC | `list(string)` | n/a | `rt-123456g` | yes
database_host | Entrypoint to database | `string` | n/a | `your-rds-instans.amazonaws.com` | yes
database_name | Name of database which need to backup | `string` | n/a | `test_db` | yes
database_user | Username with read access to database | `string` | n/a | `test_db_user` | yes 
database_pass | Password of user with read access to database | `string` | n/a | `secretpass` | yes 
cron_expression | Cron expression for backup trigger | `string` | n/a | `cron(0 5,8,11,14,17,20 * * ? *)` | yes 

## Outputs

Name | Description
--- | --- 
s3_domain_name | Domain name of s3 bucket with backups
lambda_function_name | Lambda function name
lambda_function_role | Role name associated with lambda function
lambda_function_arn | ARN of lambda function
lambda_function_log_group | Lambda log group name in CloudWatch

