###################### Outputs ######################
# output "public_ip_ec2" {
#   value = aws_instance.ec2_terraform.public_ip
# }

output "connect_ssh" {
  value = "ssh ubuntu@${aws_eip.eip_terraform.public_ip} -i ~/.ssh/key"
}
###################### ####### ######################