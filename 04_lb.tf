
resource "aws_lb_target_group" "poc-lb-target-group" {
  name     = "poc-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.poc-vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}


resource "aws_lb_target_group_attachment" "attach-instance" {
  target_group_arn = aws_lb_target_group.poc-lb-target-group.arn
  target_id        = aws_instance.poc-instance.id
  port             = 80
}

resource "aws_lb" "poc-lb" {
  name               = "poc-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-poc-security-group.id]
  subnets            = [data.aws_subnet.poc-vpc-public-us-east-1a.id, data.aws_subnet.poc-vpc-public-us-east-1b.id]

  enable_deletion_protection = false


}
resource "aws_lb_listener" "poc-listner" {
  load_balancer_arn = aws_lb.poc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poc-lb-target-group.arn
  }
}