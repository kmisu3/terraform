locals {
  project_prefix = "my-project"
  environment    = "dev"
  account_id     = data.aws_caller_identity.current.account_id
  
  # S3バケット名の構成
  state_bucket_name = "${local.project_prefix}-terraform-state-${local.environment}-${local.account_id}"
  
  # その他の共通変数
  tags = {
    Environment = local.environment
    Project     = local.project_prefix
    ManagedBy   = "Terraform"
  }
}

data "aws_caller_identity" "current" {} 