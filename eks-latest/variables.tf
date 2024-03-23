###############################VPC##################################
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "Instance tenancy of the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  description = "Should be true if you want to enable DNS support in the VPC"
  type        = bool
}

variable "availability_zones" {
  description = "List of availability zones in the region where subnets will be created"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

############################TAGS#################################
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Production"
  }
}
variable "vpc_tags" {
  description = "Tags for the VPC resources"
  type        = map(string)
  default = {
    Name = "MyVPC"
    Environment = "Production"
  }
}