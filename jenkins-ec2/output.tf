# VPC Output
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}

# Subnets Outputs
# output "private_subnet_ids" {
#   value = [
#     aws_subnet.private_1.id,
#     aws_subnet.private_2.id,
#   ]
#   description = "The IDs of the private subnets"
# }

output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
  ]
  description = "The IDs of the public subnets"
}

# Internet Gateway Output
output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway"
}

# NAT Gateway Output
# output "nat_gateway_id" {
#   value       = aws_nat_gateway.nat.id
#   description = "The ID of the NAT Gateway"
# }

# Route Tables Outputs
# output "private_route_table_id" {
#   value       = aws_route_table.private.id
#   description = "The ID of the private route table"
# }

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "The ID of the public route table"
}
