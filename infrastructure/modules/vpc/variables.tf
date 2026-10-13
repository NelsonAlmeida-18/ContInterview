variable "name" {
  description = "Name prefix used for the Name tag of every resource."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "cidr_block" {
  description = "IPv4 CIDR block of the VPC, e.g. 10.0.0.0/16."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR."
  }
}

variable "tags" {
  description = "Tags applied to every resource. The module-generated Name tag takes precedence."
  type        = map(string)
  default     = {}
}
