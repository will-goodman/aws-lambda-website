
terraform {
  required_version = ">=0.12.19"
  backend "s3" {
    bucket = "m9w4y-terraform-state"
    key = "awslambdawebsite.tfstate"
    region = "eu-west-2"
    dynamodb_table = "tf-state-lock-table"
    encrypt = true
  }
}
