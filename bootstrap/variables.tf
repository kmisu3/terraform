variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_prefix" {
  description = "プロジェクト固有のプレフィックス（S3バケット名の一部として使用）"
  type        = string
  default     = "my-project"
} 