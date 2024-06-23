resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = 7
}
