provider "aws" {
  version = "~> 2.0"
  region = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

provider "spotinst" {
  version = "~> 1.17"
  token   = var.spotinist_token
  account = var.spotinist_account
}
