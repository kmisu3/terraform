output "terraform_state_bucket" {
  description = "dev環境のTerraform状態管理用S3バケット名"
  value       = local.environment
}

output "terraform_state_bucket_arn" {
  description = "dev環境のTerraform状態管理用S3バケットのARN"
  value       = module.terraform_state_bucket.bucket_arn
} 