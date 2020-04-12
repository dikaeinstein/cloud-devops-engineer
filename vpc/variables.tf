variable "environment_name" {
  description = "An environment name that will be prefixed to resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "instance_tenancy" {
  description = "Tenancy of instances spin up within VPC."
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Whether or not the VPC has DNS support."
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPv6 CIDR Block."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to resources in this module."
  type        = map(string)
}

variable "create_igw" {
  description = "Create and attach an InternetGateway to the VPC"
  type        = bool
}

variable "private_subnets" {
  description = "List of IPv4 CIDR block for the private subnet."
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "List of IPv4 CIDR block for the public subnet."
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Instances launched into the subnet should be assigned a public IP address"
  type        = bool
  default     = true
}

variable "private_subnet_ipv6_cidrs" {
  description = "List of The IPv6 network range for the private subnet, in CIDR notation. The subnet size must use a /64 prefix length."
  type        = list(string)
  default     = []
}

variable "public_subnet_ipv6_cidrs" {
  description = "List of The IPv6 network range for the public subnet, in CIDR notation. The subnet size must use a /64 prefix length."
  type        = list(string)
  default     = []
}

variable "private_assign_ipv6_address_on_creation" {
  description = "Network interfaces created in the private subnet should be assigned an IPv6 address."
  type        = bool
  default     = false
}

variable "public_assign_ipv6_address_on_creation" {
  description = "Network interfaces created in the public subnet should be assigned an IPv6 address."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Whether a single NAT Gateway is created."
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway."
  type        = bool
  default     = false
}
