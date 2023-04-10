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
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2
  
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
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
  # instance = aws_instance.ec2_instance.id
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


resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private.id 

}



