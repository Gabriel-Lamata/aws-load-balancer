# EC2 Instances
resource "aws_instance" "instance_1a" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [var.security_group_id]
  user_data_base64       = base64encode(var.user_data)
  key_name               = var.key_name
}

resource "aws_instance" "instance_1b" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnets[1]
  vpc_security_group_ids = [var.security_group_id]
  user_data_base64       = base64encode(var.user_data)
  key_name               = var.key_name
}

# Target Group
resource "aws_lb_target_group" "ec2_lb_tg" {
  name     = "ec2-lb-tg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
}

# Attach Instances
resource "aws_lb_target_group_attachment" "tg_instance_1a" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance_1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_instance_1b" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance_1b.id
  port             = 80
}

# Load Balancer
resource "aws_lb" "ec2_lb" {
  name               = "ec2-lb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.security_group_id]
}

# Listener
resource "aws_lb_listener" "ec2_lb_listener" {
  load_balancer_arn = aws_lb.ec2_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  }
}
