provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name    = "Enterprise-VPC"
    Project = "Modernization-EKS"
  }
}

resource "aws_subnet" "eks_private_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name"                            = "EKS-Private-1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "eks_private_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name"                            = "EKS-Private-2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
