output "node_public_ips" {
  value = module.node.public_ips
}

output "node_public_dns" {
  value = module.node.public_dns
}

# output "static_pipeline_domain_nane" {
#   value = module.static_pipeline.bucket_domain_name
# }
