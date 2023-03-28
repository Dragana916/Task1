resource "aws_instance" "ec2_instance" {
  ami           = "ami-0df24e148fdb9f1d8"
  instance_type = "t2.micro"
  key_name      =  "vockey"
  subnet_id     =  aws_subnet.public_subnet.id
  user_data = "${file("installWordPress.sh")}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_web.id,
  ]

  tags = {
    Name = "ec2_instance"
  }
}