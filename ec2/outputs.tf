output "ids" {
  description = "List of IDs of instances."
  value       = aws_instance.this.*.id
}

output "arns" {
  description = "List of ARNs of instances."
  value       = aws_instance.this.*.arn
}

output "public_ips" {
  description = "List of public IP addresses assigned to the instances, if applicable."
  value       = aws_instance.this.*.public_ip
}

output "ipv6_addresses" {
  description = "List of assigned IPv6 addresses of instances."
  value       = aws_instance.this.*.ipv6_addresses
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances."
  value       = aws_instance.this.*.private_dns
}

output "private_ips" {
  description = "List of private IP addresses assigned to the instances."
  value       = aws_instance.this.*.private_ip
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances."
  value       = aws_instance.this.*.public_dns
}
