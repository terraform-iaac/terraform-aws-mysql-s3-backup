output "s3_domain_name" {
  value = aws_s3_bucket.backup_bucket.bucket_domain_name
}
output "lambda_function_arn" {
  value = module.lambda_function_container_image.lambda_function_arn
}
output "lambda_function_log_group" {
  value = module.lambda_function_container_image.lambda_cloudwatch_log_group_name
}
output "lambda_function_name" {
  value = module.lambda_function_container_image.lambda_function_name
}
output "lambda_function_role" {
  value = aws_iam_role.lambda_function_role.name
}