
variable "region" {
  description = "Region to deploy to."
  default = "eu-west-2"
}

//VPC
variable "vpc_name" {
  description = "Name to give to the VPC."
  default = "awswebsite"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC."
  default = "10.0.0.0/16"
}

variable "subnet_availability_zone" {
  description = "AWS availability zone for the subnets."
  default = "euw2-az1"
}

variable "public_cidr_range" {
  description = "CIDR range for the first public subnet. Must be within the VPC CIDR range."
  default = "10.0.1.0/24"
}

variable "second_public_cidr_range" {
  description = "CIDR range for the second public subnet. Must be within the VPC CIDR range."
  default = "10.0.3.0/24"
}

variable "private_cidr_range" {
  description = "CIDR range for the first private subnet. Must be within the VPC CIDR range."
  default = "10.0.2.0/24"
}

variable "second_private_cidr_range" {
  description = "CIDR range for the second private subnet. Must be within the VPC CIDR range."
  default = "10.0.4.0/24"
}

//UI
variable "ui_lambda_function_name" {
  description = "Name of the UI lambda function with the ending dropped e.g. test.py -> test"
  default = "test"
}

variable "ui_lambda_handler" {
  description = "Path to the lambda handler for the UI e.g. /path/file.lambda_handler"
  default = "test.lambda_handler"
}

variable "ui_lambda_logs_retention" {
  description = "How long to store the UI lambda logs in days."
  default = 7
}

variable "ui_lambda_memory_size" {
  description = "Memory to allocate to the UI lambda in MB. Default 128MB."
  default = 128
}

variable "ui_lambda_timeout" {
  description = "Timeout in seconds for the UI lambda. Default 3 seconds."
  default = 3
}

variable "ui_lambda_runtime" {
  description = "Runtime environment for the UI lambda."
  default = "python3.7"
}

variable "ui_lambda_filename" {
  description = "Path to the zip file containing the lambda code."
  default = "../test.zip"
}

variable "ui_lambda_sg_name" {
  description = "Name for the security group assigned to the UI lambda."
  default = "awswebsite-ui-sg"
}
