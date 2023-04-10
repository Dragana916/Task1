# Launch Template Resource
resource "aws_launch_template" "launchtemplate4" {
  name = "launchtemplate4"
  image_id = "ami-0df24e148fdb9f1d8"
  # image_id = "ami-0747e613a2a1ff483"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]
  key_name = "vockey"
  user_data = base64encode(file("${path.module}/installWordPress.sh"))
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Wordpresslaunchtemplate"
    }
  }
}