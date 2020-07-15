output "node_public_ips" {
  value = module.node.public_ips
}

output "node_public_dns" {
  value = module.node.public_dns
}

# output "static_pipeline_domain_name" {
#   value = module.static_pipeline.bucket_domain_name
# }

# output "static_website_domain_name" {
#   value = module.static_pipeline.bucket_website_endpoint
# }
