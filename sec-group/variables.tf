variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "description" {
  description = "The security group description."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to attach to the security group."
  type        = list(string)
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to attach to the security group."
  type        = list(string)
  default     = []
}


variable "tags" {
  description = "A mapping of tags to assign to security group."
  type        = map(string)
  default     = {}
}
