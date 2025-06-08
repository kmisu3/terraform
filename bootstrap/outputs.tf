output "terraform_state_bucket_dev" {
  description = "開発環境のTerraform状態を保存するS3バケットの名前"
  value       = aws_s3_bucket.terraform_state_dev.id
}

output "terraform_state_bucket_stg" {
  description = "ステージング環境のTerraform状態を保存するS3バケットの名前"
  value       = aws_s3_bucket.terraform_state_stg.id
}

output "terraform_state_bucket_prod" {
  description = "本番環境のTerraform状態を保存するS3バケットの名前"
  value       = aws_s3_bucket.terraform_state_prod.id
} 