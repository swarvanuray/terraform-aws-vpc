variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "environment" {
  description = "Environment name for tagging resources (e.g., dev, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment name cannot be empty."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR must be provided."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR must be provided."
  }
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two availability zones must be provided for high availability."
  }
}

variable "enable_internet_gateway" {
  description = "Feature flag to enable/disable Internet Gateway"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Feature flag to enable/disable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_virtual_private_gateway" {
  description = "Feature flag to enable/disable Virtual Private Gateway"
  type        = bool
  default     = false
}

variable "public_nacl_ingress_ports" {
  description = "List of ports to allow in public NACL ingress rules"
  type        = list(number)
  default     = [80, 443, 22]

  validation {
    condition     = alltrue([for port in var.public_nacl_ingress_ports : port >= 0 && port <= 65535])
    error_message = "Ports must be between 0 and 65535."
  }
}

variable "flow_log_retention_days" {
  description = "Retention period in days for VPC flow logs"
  type        = number
  default     = 7

  validation {
    condition     = var.flow_log_retention_days >= 1
    error_message = "Retention period must be at least 1 day."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.common_tags : length(k) > 0 && length(v) > 0])
    error_message = "Tag keys and values cannot be empty."
  }
}