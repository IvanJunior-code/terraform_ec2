terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


###################### Key Pair ######################
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = var.access_key
}
###################### ### #### ######################


###################### EC2 ######################
resource "aws_instance" "ec2" {
  ami                    = "ami-01c146ce0993b7884" #Ubuntu-2023-10-27T15-45 # aws ec2 describe-images --owners amazon --query 'Images[*].[ImageId, Name]' --output table --region us-east-1 | grep Ubuntu-2023-10
  instance_type          = "t3.small"              # aws ec2 describe-instance-types --query 'InstanceTypes[*].[InstanceType, VCpuInfo.DefaultVCpus, MemoryInfo.SizeInMiB, NetworkInfo.NetworkPerformance, StorageInfo.TotalVolumeSize]' --output table | grep small
  subnet_id              = aws_subnet.subnet_terraform.id
  vpc_security_group_ids = [aws_security_group.sg_terraform.id]

  tags = {
    Name = "EC2"
  }

  key_name = aws_key_pair.ssh_key.key_name
}
###################### ### ######################


###################### VPC ######################
resource "aws_vpc" "vpc_terraform" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "vpc_terraform"
  }
}
###################### ### ######################


###################### Subnet ######################
resource "aws_subnet" "subnet_terraform" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_terraform"
  }

}
###################### ###### ######################


###################### Security Group ######################
resource "aws_security_group" "sg_terraform" {
  name        = "sg_terraform"
  description = "Allow SSH, HTTP, HTTPS and DNS inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc_terraform.id

  tags = {
    Name = "sg_terraform"
  }
}
###################### ######## ##### ######################


###################### Security Group Ingress Rule ######################
resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_ipv4" {
  security_group_id = aws_security_group.sg_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
###################### ######## ##### ####### #### ######################


###################### Security Group Egress Rule ######################
resource "aws_vpc_security_group_egress_rule" "egress_ssh_ipv4" {
  security_group_id = aws_security_group.sg_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
###################### ######## ##### ###### #### ######################


###################### Internet Gateway ######################
resource "aws_internet_gateway" "gw_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "Internet Gateway Terraform"
  }
}
###################### ######## ####### ######################


###################### Route Table ######################
resource "aws_route_table" "route_table_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0" #"10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw_terraform.id
  }

  tags = {
    Name = "Route Table Terraform"
  }
}
###################### ##### ##### ######################


###################### Route Table Association ######################
resource "aws_route_table_association" "association_subnet_route" {
  subnet_id      = aws_subnet.subnet_terraform.id
  route_table_id = aws_route_table.route_table_terraform.id
}
###################### ##### ##### ########### ######################