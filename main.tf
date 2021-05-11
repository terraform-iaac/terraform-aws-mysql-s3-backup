module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.database_name}-RDS-backup-container"
  description   = "SQL backup of ${var.database_name} database from RDS instance"

  create_package = false
  create_layer   = false
  create_role    = false

  image_uri    = "${var.backup_image_repo}:${var.backup_image_tag}"
  package_type = "Image"

  lambda_role            = aws_iam_role.lambda_function_role.arn
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids

  environment_variables = {
    hostDB1     = var.database_host
    databaseDB1 = var.database_name
    userDB1     = var.database_user
    passDB1     = var.database_pass
    s3Bucket    = aws_s3_bucket.backup_bucket.id
  }

  tags = {
    env        = var.env
    managed_by = "Terraform"
  }
}