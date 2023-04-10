resource "aws_autoscaling_group" "wordpress_autoscaling" {
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  launch_template {
    id = aws_launch_template.launchtemplate4.id 
  }
  vpc_zone_identifier  = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
  target_group_arns    = [aws_lb_target_group.front.arn]
}

# scale up alarm
resource "aws_autoscaling_policy" "cpu-policyscaleup" {
  name = "cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.wordpress_autoscaling.id
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1 
  cooldown = 300
  policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaleup" {
  alarm_name = "cpu-alarm"
  alarm_description = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = 40
  dimensions = {
  "AutoScalingGroupName" = "${aws_autoscaling_group.wordpress_autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.cpu-policyscaleup.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name = "example-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.wordpress_autoscaling.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name = "cpu-alarm-scaledown"
  alarm_description = "cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = 40
  dimensions = {
  "AutoScalingGroupName" = "${aws_autoscaling_group.wordpress_autoscaling.name}"
  }
  actions_enabled = var.actions_enabled_up
  alarm_actions = ["${aws_autoscaling_policy.cpu-policy-scaledown.arn}"]
}