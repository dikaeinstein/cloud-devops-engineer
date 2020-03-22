output "bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamo_table_name" {
  value = (length(aws_dynamodb_table.terraform_locks) == 1
  ? aws_dynamodb_table.terraform_locks[0].id : "")
}
