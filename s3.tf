resource "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.global_prefix}-rds-backup"
  acl    = "private"

  tags = {
    env = var.env
    managed_by = "Terraform"
  }
}