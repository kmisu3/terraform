variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

# VPC設定
variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロックのリスト"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロックのリスト"
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.20.0/24"]
}

variable "create_internet_gateway" {
  description = "Internet Gatewayを作成するかどうか"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "NAT Gatewayを作成するかどうか"
  type        = bool
  default     = true
} 