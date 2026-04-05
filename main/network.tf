#VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "EKS-VPC"
    "kubernetes.io/cluster/titan-eks-cluster" = "shared"
  }
}

#Internet Gateway

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  
  tags = {
    Name = "EKS-Internet-Gateway"
  }
}

#Public Subnets ( For NAT & Public Load Balancers )
#Public 1
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "EKS-Public-1"
    "kubernetes.io/cluster/titan-eks-cluster" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
}

#Public 2
resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "EKS-Public-2"
    "kubernetes.io/cluster/titan-eks-cluster" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
}

#Private Subnets ( For Worker Nodes & Pods )
#Private 1
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-central-1a"
  
  tags = {
    Name = "EKS-Private-1"
    "kubernetes.io/cluster/titan-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#Private 2
resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "EKS-Private-2"
    "kubernetes.io/cluster/titan-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "eks_eip" {
  domain = "vpc"
}

#NAT Gateway
resource "aws_nat_gateway" "eks_ngw" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id = aws_subnet.public_1.id 

  depends_on = [aws_internet_gateway.eks_igw]

  tags = {
    Name = "EKS-NAT-Gateway"
  }

}

#Route table for Internet Gateway

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  
}

#Route table for NAT Gateway

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_ngw.id
  }
}

#Association route tables with subnets
resource "aws_route_table_association" "pub_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pri_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "pri_2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}




