provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# Terraformステート管理用S3バケットモジュール
module "terraform_state_bucket" {
  source = "./modules/terraform-state-bucket"
  
  project_prefix = var.project_prefix
  environment    = var.environment
  account_id     = data.aws_caller_identity.current.account_id
  region         = var.region
} 