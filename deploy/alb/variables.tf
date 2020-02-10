
variable "alb_name" {
  description = "Name to give to the ALB."
}

variable "alb_sg_name" {
  description = "Name for the security group assigned to the ALB."
}

variable "alb_ui_target_group_name" {
  description = "Name for the ALB target group which forwards to the UI lambda function."
}

variable "alb_api_target_group_name" {
  description = "Name for the ALB target group which forwards to the API lambda function."
}

variable "vpc_id" {
  description = "The ID of the VPC to place the ALB inside."
}

variable "subnets" {
  description = "Subnets to connect the ALB to."
  type = list(string)
}

variable "ui_lambda_arn" {
  description = "ARN of the Lambda hosting the UI."
}

variable "api_lambda_arn" {
  description = "ARN of the Lambda hosting the API."
}
