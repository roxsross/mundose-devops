resource "aws_lb_target_group" "flask_app_demo" {
  name        = "${var.app_id}-${var.app_env}-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb" "flask_app_demo" {
  name                       = "${var.app_id}-${var.app_env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.flask_app_demo.id]
  subnets                    = var.subnets
  enable_deletion_protection = false
  tags                       = local.common_tags
}
resource "aws_lb_listener" "flask_app_demo" {
  load_balancer_arn = aws_lb.flask_app_demo.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_app_demo.arn
  }
  tags = local.common_tags
}

resource "aws_lb_listener_rule" "flask_app_demo" {
  listener_arn = aws_lb_listener.flask_app_demo.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_app_demo.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
  tags = local.common_tags

}