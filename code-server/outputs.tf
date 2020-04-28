output "public_ip" {
  value = module.instance.public_ips[0]
}

output "public_dns" {
  value = module.instance.public_dns[0]
}
