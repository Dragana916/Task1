resource "aws_lb" "front" {
  name = "front"
  internal = false 
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.allow_ssh_tcp.id]

  enable_deletion_protection = false 

  tags = {
    Environment = "front" 
  }
  
}