variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "The resource name prefix and Name tag of the load balancer."
  type        = string
  default     = null
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "internal" {
  description = " If true, the LB will be internal."
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer."
  type        = list(string)
  default     = null
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers."
  type        = bool
  default     = false
}

variable "subnet_mapping" {
  description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
  type        = list(map(string))
  default     = []
}

variable "listeners" {
  description = "A list of maps describing the listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08)"
  type        = any
  default     = []
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer will be deployed."
  type        = string
  default     = null
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: backend_protocol, backend_port."
  type        = any
  default     = []
}

variable "environment_name" {
  description = "An environment name that will be prefixed to resource names."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
