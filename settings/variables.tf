variable "project_prefix" {
  description = "プロジェクトのプレフィックス"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "環境名 (dev, stg, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "環境名は dev, stg, prod のいずれかを指定してください。"
  }
}

variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
} 