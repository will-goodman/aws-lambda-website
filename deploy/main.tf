
module "vpc" {
  source = "github.com/will-goodman/aws-terraform-modules//vpc"

  vpc_name = var.vpc_name

  vpc_cidr = var.vpc_cidr
  subnet_availability_zone = var.subnet_availability_zone
  public_cidr_range = var.public_cidr_range
  private_cidr_range = var.private_cidr_range
}
