locals {
  project_prefix = "my-project"
  account_id     = data.aws_caller_identity.current.account_id
  environment    = "prod"
  region         = "ap-northeast-1"
} 