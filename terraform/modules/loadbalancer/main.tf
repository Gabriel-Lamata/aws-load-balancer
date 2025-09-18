# EC2 INSTANCES
data "template_file" "user_data" {
  template = var.user_data
}

resource "aws_instance" "instance_1a" {
  ami                    = "ami-00a929b66ed6e0de6"
  instance_type          = "t2.micro"
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [var.security_group_id]
  user_data_base64       = base64encode(data.template_file.user_data.rendered)
  key_name               = "vockey"
}

resource "aws_instance" "instance_1b" {
  ami                    = "ami-00a929b66ed6e0de6"
  instance_type          = "t2.micro"
  subnet_id              = var.subnets[1]
  vpc_security_group_ids = [var.security_group_id]
  user_data_base64       = base64encode(data.template_file.user_data.rendered)
  key_name               = "vockey"
}

# LOAD BALANCER
resource "aws_lb" "ec2_lb" {
  name               = "ec2-lb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.security_group_id]
}

# TARGET GROUP
resource "aws_lb_target_group" "ec2_lb_tg" {
  name     = "ec2-lb-tg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_1a" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance_1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_1b" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance_1b.id
  port             = 80
}

# LISTENER
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.ec2_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  }
}
