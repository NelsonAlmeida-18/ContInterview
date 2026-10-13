output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  value       = aws_vpc.this.cidr_block
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}
