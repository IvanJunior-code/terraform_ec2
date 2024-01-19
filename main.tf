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
  ami           = "ami-01c146ce0993b7884" #Ubuntu-2023-10-27T15-45 # aws ec2 describe-images --owners amazon --query 'Images[*].[ImageId, Name]' --output table --region us-east-1 | grep Ubuntu-2023-10
  instance_type = "t3.small"              # aws ec2 describe-instance-types --query 'InstanceTypes[*].[InstanceType, VCpuInfo.DefaultVCpus, MemoryInfo.SizeInMiB, NetworkInfo.NetworkPerformance, StorageInfo.TotalVolumeSize]' --output table | grep small

  tags = {
    Name = "EC2"
  }

  key_name = aws_key_pair.ssh_key.key_name
}
###################### ### ######################
