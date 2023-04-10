# resource "aws_lb_target_group_attachment" "attach-app1" {
#   target_group_arn = aws_lb_target_group.front.arn
#   target_id        = aws_instance.ec2_instance.id 
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "attach-app2" {
#   target_group_arn = aws_lb_target_group.front.arn
#   target_id        = aws_instance.ec2_instance_2.id 
#   port             = 80
# }