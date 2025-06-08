output "terraform_state_bucket" {
  description = "ステージング環境のTerraform状態管理用S3バケット名"
  value       = aws_s3_bucket.terraform_state.bucket
} 