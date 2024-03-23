#VPC

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




#EC2 


variable "key_name" {
  description = "The name of the SSH key pair to attach to the EC2 instances"
  type        = string
  # No default value is provided to ensure that a specific key name is intentionally chosen at runtime or in a tfvars file.
}

variable "ec2_type" {
  description = "The instance type of the EC2 instance"
  type        = string
  # Providing a default value can be optional based on whether you want to enforce setting this for every deployment.
}

variable "ec2_amiid" {
  description = "The AMI ID to be used for the EC2 instance"
  type        = string
  # AMI IDs are specific to each deployment and should be provided at runtime or in a tfvars file.
}




##TAGS
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

variable "ec2_tags" {
  description = "Tags for the EC2 instance"
  type        = map(string)
  default = {
    Name = "MyEC2Instance"
    Environment = "Production"
  }
}

variable "security_group_tags" {
  description = "Tags for the security group"
  type        = map(string)
  default = {
    Name = "MySecurityGroup"
    Environment = "Production"
  }
}


