resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  acl           = var.acl
  force_destroy = var.force_destroy

  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  tags = {
    Name = var.tag_name
  }
}

resource "aws_s3_bucket_policy" "this" {
  depends_on = [aws_s3_bucket.this]
  bucket     = var.bucket_name

  policy = templatefile(var.policy_path, {})
}
