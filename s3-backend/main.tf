resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = var.tag_name
  }
}

# Create dynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  count        = var.dynamo_table_name != "" ? 1 : 0
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = var.tag_name
  }
}
