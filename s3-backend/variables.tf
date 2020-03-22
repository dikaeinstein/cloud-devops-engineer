variable "bucket_name" {
  description = "The bucket name."
  type        = string
}

variable "dynamo_table_name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
  default     = ""
}

variable "tag_name" {
  description = "Tag name for resources in the S3 backend"
  type        = string
}
