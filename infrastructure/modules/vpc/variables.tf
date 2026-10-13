variable "name" {
  description = "Name prefix used for the Name tag of every resource."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty"
  }
}

variable "cidr_block" {
  description = "IPv4 CIDR block of the VPC, e.g. 10.0.0.0/16."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR"
  }
}

variable "tags" {
  description = "Tags applied to every resource. The module-generated Name tag takes precedence."
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "Public subnets keyed by a stable name. Each gets a route to the Internet Gateway and auto-assigns public IPs."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}

  validation {
    condition     = alltrue([for s in values(var.public_subnets) : can(cidrnetmask(s.cidr_block))])
    error_message = "All public subnet cidr_blocks must be a valid IPv4"
  }
}

variable "private_subnets" {
  description = "Private subnets keyed by a stable name. They have no route to the internet."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}

  validation {
    condition     = alltrue([for s in values(var.private_subnets) : can(cidrnetmask(s.cidr_block))])
    error_message = "All private subnet cidr_blocks must be a valid IPv4"
  }
}