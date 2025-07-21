# Terraformステート管理用S3バケットモジュール
module "terraform_state_bucket" {
  source = "../modules/terraform-state-bucket"
  
  project_prefix = local.project_prefix
  environment    = local.environment
  account_id     = data.aws_caller_identity.current.account_id
  region         = var.region
}

# AWSアカウントID取得
data "aws_caller_identity" "current" {} 