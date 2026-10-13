output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Map of public subnet key => subnet ID."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of private subnet key => subnet ID."
  value       = module.vpc.private_subnet_ids
}
