#-----------------------------------------------------------------------------------------
###### VPC CREATION  ######
#-----------------------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
    
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.vpc_tags
}




#-----------------------------------------------------------------------------------------
###### SUBNET CREATION  ######
#-----------------------------------------------------------------------------------------


# # Private Subnet 01
# resource "aws_subnet" "private_1" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet_cidr_blocks[0]
#   availability_zone = var.availability_zones[0]
#   tags              = var.tags
# }

# # Private Subnet 02
# resource "aws_subnet" "private_2" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet_cidr_blocks[1]
#   availability_zone = var.availability_zones[1]
#   tags              = var.tags
# }

# Public Subnet 01
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

# Public Subnet 02
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
}



# #-----------------------------------------------------------------------------------------
# ######INTERNET GATEWAY ######
# #-----------------------------------------------------------------------------------------


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

# #-----------------------------------------------------------------------------------------
# ###### NAT GATEWAY ######
# #-----------------------------------------------------------------------------------------
# # NAT Gateway (Assuming use of public_1 subnet for NAT Gateway)
# resource "aws_eip" "nat" {
#   vpc = true
#   tags = {
#     Name = "nat-eip"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_1.id
#   tags = {
#     Name = "nat-gateway"
#   }
#   depends_on = [aws_internet_gateway.igw]
# }

#-----------------------------------------------------------------------------------------
###### ROUTE TABLE ######
#-----------------------------------------------------------------------------------------

# # Private Route Table
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
#   tags = {
#     Name = "private-route-table"
#   }
# }

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#-----------------------------------------------------------------------------------------
###### ROUTING TABLE and ASSOCIATION ######
#-----------------------------------------------------------------------------------------

# routing table association

# Private Subnets
# resource "aws_route_table_association" "private_1" {
#   subnet_id      = aws_subnet.private_1.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_2" {
#   subnet_id      = aws_subnet.private_2.id
#   route_table_id = aws_route_table.private.id
# }

# Public Subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


#-----------------------------------------------------------------------------------------
###### EC2 SERVER CREATION ######
#-----------------------------------------------------------------------------------------


resource "aws_instance" "ec2_instance" {
  ami                    = var.ec2_amiid
  instance_type          = var.ec2_type               
  key_name               = var.key_name  
  user_data                   = file("jenkins-install.sh")          
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.asg_ec2.id]
  associate_public_ip_address = true
  tags = var.ec2_tags
}
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key" {
  key_name   = var.key_name
  public_key = tls_private_key.tls.public_key_openssh
}


# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.aws_key.key_name}.pem"
  content  = tls_private_key.tls.private_key_pem
  file_permission = "0400"
}
# creating Security group to allow port inbound
resource "aws_security_group" "asg_ec2" {  
  name        = "sg"
  description = "Security group for EC2"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ideally, restrict this to a known IP range for security.
    description = "SSH"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public access, consider restricting this as well.
    description = "HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags        = var.security_group_tags
}  
