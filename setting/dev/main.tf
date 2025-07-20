provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# 開発環境のステート管理用S3バケット
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.project_prefix}-terraform-state-dev-${local.account_id}"

  tags = {
    Environment = "dev"
    Project     = local.project_prefix
    ManagedBy   = "Terraform"
  }
}

# バケット設定
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 