resource "aws_cloudfront_origin_access_identity" "this" {}

module "s3_site" {
  source = "../s3"

  bucket_name = "dikaeinstein-cde-nd-website"
  acl         = "public-read"
  tag_name    = "UdacityStaticWebsite"
  policy_path = "${path.module}/templates/udacity-website.json"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}

module "site_distribution" {
  source = "../cloudfront"

  tag_name = "UdacityStaticWebsite"
  origins = [
    {
      domain_name            = module.s3_site.bucket_domain_name
      origin_id              = module.s3_site.bucket_name
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
      custom_headers         = []
    }
  ]
  default_cache_behavior = [
    {
      allowed_methods  = ["GET", "HEAD"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = module.s3_site.bucket_name

      forward_query_string = false
      forward_headers      = []
      forward_cookies      = "all"

      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
    }
  ]

  custom_error_responses = [
    {
      error_caching_min_ttl = 0
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = 0
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]
}
