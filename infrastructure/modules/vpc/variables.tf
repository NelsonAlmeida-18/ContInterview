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
    condition     = can(cidrnetmask(var.cidr_block)) && try(tonumber(split("/", var.cidr_block)[1]) >= 16 && tonumber(split("/", var.cidr_block)[1]) <= 28, false)
    error_message = "cidr_block must be a valid IPv4 CIDR between /16 and /28"
  }
}

variable "tags" {
  description = "Tags applied to every resource. The module-generated Name tag takes precedence."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "public_subnets" {
  description = "Public subnets keyed by a stable name. Each gets a route to the Internet Gateway and auto-assigns public IPs."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for s in values(var.public_subnets) : try(
        tonumber(split("/", s.cidr_block)[1]) >= tonumber(split("/", var.cidr_block)[1]) &&
        tonumber(split("/", s.cidr_block)[1]) <= 28 &&
        cidrhost("${cidrhost(s.cidr_block, 0)}/${split("/", var.cidr_block)[1]}", 0) == cidrhost(var.cidr_block, 0),
        false
      )
    ])
    error_message = "All public subnet cidr_blocks must be a valid IPv4 CIDR inside the VPC cidr_block"
  }
}

variable "private_subnets" {
  description = "Private subnets keyed by a stable name. They have no route to the internet."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for s in values(var.private_subnets) : try(
        tonumber(split("/", s.cidr_block)[1]) >= tonumber(split("/", var.cidr_block)[1]) &&
        tonumber(split("/", s.cidr_block)[1]) <= 28 &&
        cidrhost("${cidrhost(s.cidr_block, 0)}/${split("/", var.cidr_block)[1]}", 0) == cidrhost(var.cidr_block, 0),
        false
      )
    ])
    error_message = "All private subnet cidr_blocks must be a valid IPv4 CIDR inside the VPC cidr_block"
  }
}
