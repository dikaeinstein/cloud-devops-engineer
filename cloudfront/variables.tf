variable "origins" {
  description = "One or more origins for this distribution."
  type        = list(any)
}

variable "enabled" {
  description = "Enable the CloudFront distribution."
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "CloudFront distribution root object."
  type        = string
  default     = "index.html"
}

variable "default_cache_behavior" {
  description = "Default cache behavior for this distribution. It should contain only one element"
  type        = list(any)
  default     = []
}

variable "ordered_cache_behaviors" {
  description = "Ordered custom cache behaviors."
  type        = list(any)
  default     = []
}

variable "price_class" {
  description = "The price class for this distribution."
  type        = string
  default     = "PriceClass_All"
}

variable "tag_name" {
  description = "The tag name of the cloudfront distribution."
  type        = string
}

variable "custom_error_responses" {
  description = "List of custom error reponse to send to the client."
  type        = list(map(any))
  default     = []
}
