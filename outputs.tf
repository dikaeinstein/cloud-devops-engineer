output "static_site_bucket_name" {
  value = module.static_site.bucket_name
}

output "static_site_bucket_domain_name" {
  value = module.static_site.bucket_domain_name
}

output "static_site_distribution_id" {
  value = module.static_site.distribution_id
}

output "static_site_domain_name" {
  value = module.static_site.site_domain_name
}

output "static_static_site_status" {
  value = module.static_site.distribution_status
}
