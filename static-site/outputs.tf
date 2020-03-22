output "bucket_name" {
  value = module.s3_site.bucket_name
}

output "bucket_domain_name" {
  value = module.s3_site.bucket_domain_name
}

output "distribution_id" {
  value = module.site_distribution.id
}

output "site_domain_name" {
  value = module.site_distribution.domain_name
}

output "distribution_status" {
  value = module.site_distribution.status
}
