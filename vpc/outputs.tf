output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.this.id
}

output "public_route_tables" {
  description = "List of public route table IDs."
  value       = aws_route_table.public.*.id
}

output "private_route_tables" {
  description = "List of private route table IDs."
  value       = aws_route_table.private.*.id
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = aws_subnet.public.*.id
}
