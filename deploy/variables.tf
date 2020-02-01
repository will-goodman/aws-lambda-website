
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
  description = "CIDR range for the public subnets. Must be within the VPC CIDR range."
  default = "10.0.1.0/24"
}

variable "private_cidr_range" {
  description = "CIDR range for the public subnets. Must be within the VPC CIDR range."
  default = "10.0.2.0/24"
}