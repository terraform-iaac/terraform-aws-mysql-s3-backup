# Global variables
variable "env" {
  description = "Name of environment"
}
variable "global_prefix" {
  description = "Name of project / company/ customer"
}

# ECR repo
variable "backup_image_repo" {
  description = "Image repository name"
  default = "iaac/aws-lamda-mysql-backup"
}
variable "backup_image_tag" {
  description = "Image tag version"
  default = "latest"
}

# VPC config
variable "region" {
  description = "Name of AWS region"
}
variable "vpc_id" {
  description = "VPC ID"
}
variable "vpc_security_group_ids" {
  description = "IDs of VPC security group"
  type = list(string)
}
variable "vpc_subnet_ids" {
  description = "IDs of VPC subnets"
  type = list(string)
}
variable "route_table_ids" {
  description = "IDs of route tables associated with VPC"
  type = list(string)
}

# Function variables
variable "database_host" {
  description = "Entrypoint to database"
}
variable "database_name" {
  description = "Name of database which need to backup"
}
variable "database_user" {
  description = "Username with read access to database"
}
variable "database_pass" {
  description = "Password of user with read access to database"
}

variable "cron_expression" {
  description = "Cron expression for backup trigger (example: cron(0 5,8,11,14,17,20 * * ? *) - everyday every 3 hours from 8 to 20 o`clock)"
}