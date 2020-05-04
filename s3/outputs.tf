output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.this.website_endpoint
}
