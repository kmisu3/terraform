variable "name_prefix" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロックのリスト"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロックのリスト"
  type        = list(string)
  default     = []
}

variable "enable_dns_support" {
  description = "VPCでDNSサポートを有効にするかどうか"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "VPCでDNSホスト名を有効にするかどうか"
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Internet Gatewayを作成するかどうか"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "NAT Gatewayを作成するかどうか"
  type        = bool
  default     = false
}

variable "tags" {
  description = "リソースに適用するタグ"
  type        = map(string)
  default     = {}
} 