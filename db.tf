module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.0"
  identifier = "mydb"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  username = "admin"
  db_name  = "wordpressdb"
  multi_az = "true"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # DB subnet group
#   db_subnet_group_name   = "subnet_group_db"
  create_db_subnet_group = true
  subnet_ids            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  create_db_parameter_group = "false"
  create_db_option_group    = "false"
  skip_final_snapshot       = "true"
}