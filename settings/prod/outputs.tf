output "terraform_state_bucket" {
  description = "prod環境のTerraform状態管理用S3バケット名"
  value       = module.terraform_state_bucket.bucket_name
}

output "terraform_state_bucket_arn" {
  description = "prod環境のTerraform状態管理用S3バケットのARN"
  value       = module.terraform_state_bucket.bucket_arn
} 