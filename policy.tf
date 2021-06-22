resource "aws_iam_role" "lambda_function_role" {
  name = "${var.global_prefix}-lambda-rds-backup-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_function_role_policy" {
  role = aws_iam_role.lambda_function_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "rdsActions",
            "Effect": "Allow",
            "Action": [
                "rds:RestoreDBClusterFromSnapshot",
                "rds:DescribeDBSnapshots",
                "rds:CopyDBSnapshot",
                "rds:CopyDBClusterSnapshot",
                "rds:DeleteDBSnapshot",
                "rds:DeleteDBClusterSnapshot",
                "rds:CreateDBSnapshot",
                "rds:RestoreDBInstanceFromDBSnapshot",
                "rds:CreateDBInstance",
                "rds:DescribeDBClusterSnapshots",
                "rds:DescribeDBInstances",
                "rds:DescribeDBClusters",
                "rds:DeleteDBInstance",
                "rds:CreateDBClusterSnapshot",
                "rds:ModifyDBSnapshotAttribute",
                "rds:ModifyDBClusterSnapshotAttribute",
                "rds:AddTagsToResource",
                "rds:ListTagsForResource",
                "rds:DeleteDBCluster",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeRegions",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeVpcs",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeSubnets",
                "iam:GetUser",
                "iam:GetAccountAuthorizationDetails"
            ],
            "Resource": "*"
        },
        {
            "Sid": "kmsActions",
            "Effect": "Allow",
            "Action": [
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:CreateGrant",
                "kms:DescribeKey*",
                "kms:ListKeys",
                "kms:ListAliases",
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:GenerateDataKeyWithoutPlaintext",
                "kms:ListKeys",
                "kms:ListAliases",
                "kms:ListResourceTags"
            ],
            "Resource": "*"
        },
        {
            "Sid": "s3ConsoleAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccountPublicAccessBlock",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetBucketPolicyStatus",
                "s3:GetBucketPublicAccessBlock",
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.backup_bucket.arn}"
            ]
        },
        {
            "Sid": "s3AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": [
                "${aws_s3_bucket.backup_bucket.arn}/*"
            ]
        },
        {
            "Sid": "EC2Actions",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DetachNetworkInterface",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = {
    env = var.env
    managed_by = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}