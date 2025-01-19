# locals {
#   allowed_account_ids = [var.account]
#   profile_name        = var.profile_name
#   region              = var.aws_region
# }


# provider "aws" {
#   allowed_account_ids = local.allowed_account_ids
#   region              = local.region
#   profile = local.profile_name

provider "aws" {
  default_tags {
    tags = {
      managed_by = "terraform"
    }
  }
}

#
# terraform {
#   backend "s3" {
#     bucket  = "my-tf-satae-bucket-stor"
#     key     = "my_tf_statefdfffdf"
#     profile = "au-test"
#     region  = "eu-west-1"
#   }
# }