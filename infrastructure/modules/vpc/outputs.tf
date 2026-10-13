output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  value       = aws_vpc.vpc.cidr_block
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}
output "private_route_table_id" {
  description = "Private Routing Table ID"
  value       = aws_route_table.private.id
}

output "private_subnet_ids" {
  description = "Map of private subnet key to subnet ID"
  value       = { for k, s in aws_subnet.private : k => s.id }
}

output "public_route_table_id" {
  description = "Public Routing Table ID"
  value       = aws_route_table.public.id
}

output "public_subnet_ids" {
  description = "Map of public subnet key to subnet ID"
  value       = { for k, s in aws_subnet.public : k => s.id }
}
