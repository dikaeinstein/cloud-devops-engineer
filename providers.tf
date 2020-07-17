# terraform {
#   backend "s3" {
#     bucket = "cde-nanodegree-infra-tfstate"
#     key    = "terraform.state"
#     region = "eu-west-2"

#     dynamodb_table = "cde-nanodegree-infra-tfstate-lock"
#   }
# }

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}
