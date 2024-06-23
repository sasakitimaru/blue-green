resource "aws_ecs_task_definition" "default" {
  container_definitions = jsonencode([
    {
      name      = "${local.service_name}"
      image     = "${var.ecr_repository_uri}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "${local.task_log_driver}"
        options = {
          "awslogs-region"        = "${var.region}"
          "awslogs-group"         = "${aws_cloudwatch_log_group.default.name}"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  family                   = local.task_definitions_name
  cpu                      = local.task_cpu
  memory                   = local.task_memory
  network_mode             = local.task_network_mode
  requires_compatibilities = ["${local.task_requires_compatibilities}"]
  execution_role_arn       = var.execution_role_arn
}
