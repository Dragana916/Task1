# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name    = "my_vpc"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_1
  
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

# resource "aws_subnet" "private_subnets" {
#   count = length(var.private_subnet_cidr) * length(var.availability_zones)

#   cidr_block = var.private_subnet_cidr[math.floor(count.index / length(var.availability_zones))]
#   vpc_id = aws_vpc.my_vpc.id
#   availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

#   tags = {
#     Name = "private_subnets-${count.index+1}"
#   }
# }

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_2_cidr
    availability_zone = var.availability_zone_2

    tags = {
        Name = "private_subnet_2"
  }
  
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name    = "internet_gateway"
  }
}

# Create an elastic ip
resource "aws_eip" "static-ip" {
  instance = aws_instance.ec2_instance.id
  vpc = true 

  tags = {
    Name = "elastic_ip"
  }
}


# Create an elastic ip
resource "aws_eip" "static-ip2" {
  vpc = true 

  tags = {
    Name = "elastic_ip"
  }
}

# Create the NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.static-ip2.id
  subnet_id = aws_subnet.public_subnet.id
}

# Routing Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gateway.id 
    }

    tags = {
      Name = "private_route_table"
    }
  
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private.id 
  
}

# # Security Groups
# resource "aws_security_group" "allow_ssh" {
#   name        = "allow_ssh"
#   description = "Allow SSH inbound traffic"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#    egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_ssh"
#   }
# }

# resource "aws_security_group" "allow_web" {
#   name        = "allow_web"
#   description = "Allow web traffic"
#   vpc_id      = aws_vpc.my_vpc.id

#   ingress {
#     description      = "allow web"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_web"
#   }
# }

# resource "aws_security_group" "allow_aurora_mysql" {
#   name        = "allow_aurora_mysql"
#   description = "Allow Aurora MySQL inbound traffic"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [aws_security_group.allow_ssh.id, aws_security_group.allow_web.id] # Allow access from the EC2 instance with SSH and HTTP access
#   }

#   tags = {
#     Name = "aurora-stack-allow-aurora-MySQL"
#   }
# }