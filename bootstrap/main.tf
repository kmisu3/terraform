provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# 開発環境のステート管理用S3バケット
resource "aws_s3_bucket" "terraform_state_dev" {
  bucket = "${var.project_prefix}-terraform-state-dev-${local.account_id}"

  tags = {
    Environment = "dev"
    Project     = var.project_prefix
    ManagedBy   = "Terraform"
  }
}

# ステージング環境のステート管理用S3バケット
resource "aws_s3_bucket" "terraform_state_stg" {
  bucket = "${var.project_prefix}-terraform-state-stg-${local.account_id}"

  tags = {
    Environment = "stg"
    Project     = var.project_prefix
    ManagedBy   = "Terraform"
  }
}

# 本番環境のステート管理用S3バケット
resource "aws_s3_bucket" "terraform_state_prod" {
  bucket = "${var.project_prefix}-terraform-state-prod-${local.account_id}"

  tags = {
    Environment = "prod"
    Project     = var.project_prefix
    ManagedBy   = "Terraform"
  }
}

# 全バケット共通の設定
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  for_each = {
    dev  = aws_s3_bucket.terraform_state_dev.id
    stg  = aws_s3_bucket.terraform_state_stg.id
    prod = aws_s3_bucket.terraform_state_prod.id
  }

  bucket = each.value
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  for_each = {
    dev  = aws_s3_bucket.terraform_state_dev.id
    stg  = aws_s3_bucket.terraform_state_stg.id
    prod = aws_s3_bucket.terraform_state_prod.id
  }

  bucket = each.value

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  for_each = {
    dev  = aws_s3_bucket.terraform_state_dev.id
    stg  = aws_s3_bucket.terraform_state_stg.id
    prod = aws_s3_bucket.terraform_state_prod.id
  }

  bucket                  = each.value
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 