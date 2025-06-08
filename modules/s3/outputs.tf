output "bucket_id" {
  description = "作成されたS3バケットのID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "作成されたS3バケットのARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = aws_s3_bucket.this.bucket_domain_name
} 