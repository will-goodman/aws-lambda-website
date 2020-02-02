
module "vpc" {
  source = "github.com/will-goodman/aws-terraform-modules//vpc"

  vpc_name = var.vpc_name

  vpc_cidr = var.vpc_cidr
  subnet_availability_zone = var.subnet_availability_zone
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