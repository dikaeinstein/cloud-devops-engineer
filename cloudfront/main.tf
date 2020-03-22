resource "aws_cloudfront_distribution" "this" {
  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      dynamic "custom_header" {
        for_each = length(origin.value.custom_headers) > 0 ? origin.value.custom_headers : []
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      s3_origin_config {
        origin_access_identity = origin.value.origin_access_identity
      }
    }
  }

  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = var.default_root_object
  price_class         = var.price_class

  dynamic "default_cache_behavior" {
    for_each = var.default_cache_behavior
    content {
      allowed_methods  = default_cache_behavior.value.allowed_methods
      cached_methods   = default_cache_behavior.value.cached_methods
      target_origin_id = default_cache_behavior.value.target_origin_id

      forwarded_values {
        query_string = default_cache_behavior.value.forward_query_string
        headers      = default_cache_behavior.value.forward_headers

        cookies {
          forward = default_cache_behavior.value.forward_cookies
        }
      }

      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = default_cache_behavior.value.min_ttl
      default_ttl            = default_cache_behavior.value.default_ttl
      max_ttl                = default_cache_behavior.value.max_ttl
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      # Cache behavior
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
        headers      = ordered_cache_behavior.value.forward_headers

        cookies {
          forward = ordered_cache_behavior.value.forward_cookies
        }
      }

      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      compress               = ordered_cache_behavior.value.compress
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }

  tags = {
    Name = var.tag_name
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
