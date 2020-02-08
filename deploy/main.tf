
module "vpc" {
  source = "github.com/will-goodman/aws-terraform-modules//vpc"

  vpc_name = var.vpc_name

  vpc_cidr = var.vpc_cidr
  public_cidr_range = var.public_cidr_range
  second_public_cidr_range = var.second_public_cidr_range
  private_cidr_range = var.private_cidr_range
  second_private_cidr_range = var.second_private_cidr_range
}

module "ui" {
  source = "github.com/will-goodman/aws-terraform-modules//vpc_lambda"

  function_name = var.ui_lambda_function_name
  lambda_handler = var.ui_lambda_handler
  logs_retention_period = var.ui_lambda_logs_retention

  memory_size = var.ui_lambda_memory_size
  timeout = var.ui_lambda_timeout
  runtime = var.ui_lambda_runtime

  filename = var.ui_lambda_filename

  subnet_ids = module.vpc.private_subnets
  security_groups = [aws_security_group.ui.id]
}

resource "aws_security_group" "ui" {
  name        = var.ui_lambda_sg_name
  description = "Allow HTTP/S connection."
  vpc_id      = module.vpc.vpc_id

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr_range, var.second_public_cidr_range]
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
    cidr_blocks = [var.public_cidr_range, var.second_public_cidr_range]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

module "api" {
  source = "github.com/will-goodman/aws-terraform-modules//vpc_lambda"

  function_name = var.api_lambda_function_name
  lambda_handler = var.api_lambda_handler
  logs_retention_period = var.api_lambda_logs_retention

  memory_size = var.api_lambda_memory_size
  timeout = var.api_lambda_timeout
  runtime = var.api_lambda_runtime

  filename = var.api_lambda_filename

  subnet_ids = module.vpc.private_subnets
  security_groups = [aws_security_group.api.id]
}

resource "aws_security_group" "api" {
  name        = var.api_lambda_sg_name
  description = "Allow HTTP/S connection."
  vpc_id      = module.vpc.vpc_id

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr_range, var.second_public_cidr_range]
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
    cidr_blocks = [var.public_cidr_range, var.second_public_cidr_range]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name = var.alb_name

  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]
  subnets = module.vpc.public_subnets
}

resource "aws_security_group" "alb" {
  name        = var.alb_sg_name
  description = "Allow HTTP/S connection."
  vpc_id      = module.vpc.vpc_id

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
  function_name = module.ui.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.ui_target_group.arn
}

resource "aws_lb_target_group_attachment" "ui" {
  target_group_arn = aws_lb_target_group.ui_target_group.arn
  target_id        = module.ui.arn
  depends_on       = [aws_lambda_permission.ui_with_lb]
}

resource "aws_lb_target_group" "api_target_group" {
  name        = var.alb_api_target_group_name
  target_type = "lambda"
}

resource "aws_lambda_permission" "api_with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = module.api.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.api_target_group.arn
}

resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api_target_group.arn
  target_id        = module.api.arn
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

//resource "aws_lb_listener" "https" {
//  load_balancer_arn = module.alb.alb_arn
//  port              = "443"
//  protocol          = "HTTPS"
//
//  default_action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.ui_target_group.arn
//  }
//}
//
//resource "aws_lb_listener_rule" "api_https" {
//  listener_arn = aws_lb_listener.https.arn
//  action {
//    type = "forward"
//    target_group_arn = aws_lb_target_group.api_target_group.arn
//  }
//  condition {
//    path_pattern {
//      values = ["/api/*"]
//    }
//  }
//}