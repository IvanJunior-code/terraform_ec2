##################### Variables #####################
variable "access_key" {
}

variable "tags_ManagedBy" {
  default = "Terraform"
}

variable "instance_type" {
  default = "t3.small"
}

variable "ami" {
  default = "ami-01c146ce0993b7884" #Ubuntu-2023-10-27T15-45
}

variable "key_name" {
  default = "ssh_key"
}

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}

variable "subnet_cidr_block" {
  default = "172.16.10.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "sg_name" {
  default = "sg_terraform"
}
##################### ######### #####################