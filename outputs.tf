###################### Outputs ######################
output "public_ip_ec2" {
  value = aws_instance.ec2.public_ip
}
###################### ####### ######################