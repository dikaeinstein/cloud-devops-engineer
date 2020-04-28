variable "bucket_name" {
  description = "The bucket name."
  type        = string
}

variable "policy_path" {
  description = "The path to the policy file."
  type        = string
}

variable "policy_vars" {
  description = "The template vars for the policy file."
  type        = map(string)
  default     = {}
}

variable "acl" {
  description = "The canned ACL to apply."
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket."
  type        = string
  default     = null
}

variable "tag_name" {
  description = "The tag name of the s3 bucket."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "website" {
  description = "Object that configures bucket as a website"
  type        = map(string)
  default     = {}
}
