data "aws_iam_role" "task_definition_role" {
  name = var.role
}

resource "aws_ecs_cluster" "flask_app_demo" {
  name = var.cluster_name
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "flask_app_demo" {
  family                   = "${var.app_id}-${var.app_env}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.task_definition_role.arn
  task_role_arn            = data.aws_iam_role.task_definition_role.arn
  container_definitions = jsonencode([
    {
      name  = "${var.app_id}-${var.app_env}-container"
      image = "${var.image_repo_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_id}-${var.app_env}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "flask_app_demo" {
  name = "/ecs/${var.app_id}-${var.app_env}"
  tags = local.common_tags
}

resource "aws_ecs_service" "flask_app_demo" {
  name            = "${var.app_id}-${var.app_env}-svc"
  cluster         = aws_ecs_cluster.flask_app_demo.id
  task_definition = aws_ecs_task_definition.flask_app_demo.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.flask_app_demo.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.flask_app_demo.arn
    container_name   = "${var.app_id}-${var.app_env}-container"
    container_port   = 5000
  }
  tags = local.common_tags
}

resource "aws_security_group" "flask_app_demo" {
  name   = "${var.app_id}-${var.app_env}-sg"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

