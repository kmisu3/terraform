locals {
  project_prefix = "my-project"
  environment    = "dev"
  
  # 共通タグ
  tags = {
    Environment = local.environment
    Project     = local.project_prefix
    ManagedBy   = "Terraform"
    Purpose     = "State Management"
  }
} 