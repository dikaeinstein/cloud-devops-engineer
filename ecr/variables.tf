variable "name" {
  type        = string
  description = "Name of the repository"
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
  default     = "MUTABLE"
}
