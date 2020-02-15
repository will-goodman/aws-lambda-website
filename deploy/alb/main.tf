
resource "aws_lb" "alb" {
  name = var.alb_name

  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]
  subnets = var.subnets
}

resource "aws_security_group" "alb" {
  name        = var.alb_sg_name
  description = "Allow HTTP/S connection."
  vpc_id      = var.vpc_id

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "ui_target_group" {
  name        = var.alb_ui_target_group_name
  target_type = "lambda"
}

resource "aws_lambda_permission" "ui_with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = var.ui_lambda_arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.ui_target_group.arn
}

resource "aws_lb_target_group_attachment" "ui" {
  target_group_arn = aws_lb_target_group.ui_target_group.arn
  target_id        = var.ui_lambda_arn
  depends_on       = [aws_lambda_permission.ui_with_lb]
}

resource "aws_lb_target_group" "api_target_group" {
  name        = var.alb_api_target_group_name
  target_type = "lambda"
}

resource "aws_lambda_permission" "api_with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambda_arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.api_target_group.arn
}

resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api_target_group.arn
  target_id        = var.api_lambda_arn
  depends_on       = [aws_lambda_permission.api_with_lb]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui_target_group.arn
  }
}

resource "aws_lb_listener_rule" "api_http" {
  listener_arn = aws_lb_listener.http.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = module.self_signed_cert.arn // Update in prod

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui_target_group.arn
  }
}

resource "aws_lb_listener_rule" "api_https" {
  listener_arn = aws_lb_listener.https.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

// Remove in prod and provide a proper signed certificate
module "self_signed_cert" {
  source = "github.com/will-goodman/aws-terraform-modules//self_signed_cert"

  key_algorithm = "RSA"

  common_name = aws_lb.alb.dns_name

  validity_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
