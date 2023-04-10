# resource "aws_instance" "ec2_instance" {
#   ami           = "ami-0df24e148fdb9f1d8"
#   instance_type = "t2.micro"
#   key_name      =  "vockey"
#   subnet_id     =  aws_subnet.public_subnet.id
#   user_data = "${file("installWordPress.sh")}"
#   associate_public_ip_address = true

#   vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]

#   tags = {
#     Name = "ec2_instance_1"
#   }
# }

# resource "aws_instance" "ec2_instance_2" {
#   ami           = "ami-0df24e148fdb9f1d8"
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.public_subnet_2.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]
#   key_name = "vockey"
#   associate_public_ip_address = true
#   user_data = "${file("installWordPress.sh")}"

#   tags = {
#     Name = "ec2_instance_2"
#   }
# }