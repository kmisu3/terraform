variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

# 必要に応じて追加の変数をここに定義します
# 例：VPCのCIDRブロックなど
# variable "vpc_cidr" {
#   description = "VPCのCIDRブロック"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# variable "public_subnet_cidrs" {
#   description = "パブリックサブネットのCIDRブロックのリスト"
#   type        = list(string)
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
# } 