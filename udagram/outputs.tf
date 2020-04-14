output "webapp_url" {
  value = module.webapp_lb.lb_dns_name
}

output "bastion_public_ip" {
  value = aws_eip.bastion_eip.public_ip
}

output "bastion_public_dns" {
  value = aws_eip.bastion_eip.public_dns
}
