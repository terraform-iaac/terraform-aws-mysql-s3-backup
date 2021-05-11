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

  # Image (optional)
  backup_image_repo = "my-custom-organization/my-custom-repo"
  backup_image_tag  = "v1.0.0"
}