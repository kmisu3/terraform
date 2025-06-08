variable "bucket_name" {
  description = "名前が一意になるS3バケットの名前"
  type        = string
}

variable "tags" {
  description = "バケットに付与するタグのマップ"
  type        = map(string)
  default     = {}
} 