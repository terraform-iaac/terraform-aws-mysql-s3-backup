resource "aws_cloudwatch_event_rule" "backup" {
  name        = "${var.global_prefix}-periodically-backups"
  description = "Backup ${var.database_name} database from ${var.database_host}"

  schedule_expression = var.cron_expression // type cron(0 5,8,11,14,17,20 * * ? *) - every 3 hours from 8 to 20 o`clock
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.backup.name
  arn  = module.lambda_function_container_image.lambda_function_arn
}