# terraform_state_bucket_nameはsettingsで作成・管理されているため削除

# output "alb_dns_name" {
#   description = "作成されたALBのDNS名"
#   value       = module.alb.dns_name
# }
# 
# output "api_gateway_url" {
#   description = "APIゲートウェイのURL"
#   value       = module.api_gateway.api_url
# } 

# VPC関連の出力
output "vpc_id" {
  description = "VPCのID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPCのCIDRブロック"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet GatewayのID"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "NAT GatewayのID"
  value       = module.vpc.nat_gateway_id
}

output "nat_gateway_ip" {
  description = "NAT GatewayのパブリックIP"
  value       = module.vpc.nat_gateway_ip
} 