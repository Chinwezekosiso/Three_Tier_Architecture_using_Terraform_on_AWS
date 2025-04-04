# ALB
resource "aws_lb" "Three_Tier_Arch_alb" {
  name               = "Three-Tier-Arch-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Three_Tier_Arch_web_sg.id]
  subnets            = [
    aws_subnet.Three_Tier_Arch_Public_Sub1.id,
    aws_subnet.Three_Tier_Arch_Public_Sub2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "Three_Tier_Arch_alb" 
  }
}


resource "aws_lb_target_group" "Three_Tier_Arch_web_target_group" {
  name     = "Three-Tier-Arch-web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Three_Tier_Arch_VPC.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Three_Tier_Arch_web_target_group"
  }
}

resource "aws_lb_target_group_attachment" "Three_Tier_Arch_web_server1_attachment" {
  target_group_arn = aws_lb_target_group.Three_Tier_Arch_web_target_group.arn
  target_id        = aws_instance.Three_Tier_Arch_web1_ec2_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Three_Tier_Arch_web_server2_attachment" {
  target_group_arn = aws_lb_target_group.Three_Tier_Arch_web_target_group.arn
  target_id        = aws_instance.Three_Tier_Arch_web2_ec2_instance.id
  port             = 80
}
