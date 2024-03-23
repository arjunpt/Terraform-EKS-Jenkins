vpc_cidr_block = "10.0.0.0/16"
instance_tenancy = "default"
enable_dns_hostnames = true
enable_dns_support = true
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_tags = {
  Name = "DevVPC"
  Environment = "Development"
}