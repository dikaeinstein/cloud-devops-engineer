output "target_group_arns" {
  value = aws_lb_target_group.this.*.arn
}

output "target_group_ids" {
  value = aws_lb_target_group.this.*.id
}

output "lb_arn" {
  value = aws_lb.this[0].arn
}

output "lb_dns_name" {
  value = aws_lb.this[0].dns_name
}

output "listener_arns" {
  value = aws_lb_listener.this.*.arn
}

output "listener_ids" {
  value = aws_lb_listener.this.*.id
}
