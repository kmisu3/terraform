output "bucket_name" {
  description = "Terraformステート管理用S3バケット名"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_arn" {
  description = "Terraformステート管理用S3バケットのARN"
  value       = aws_s3_bucket.terraform_state.arn
} 