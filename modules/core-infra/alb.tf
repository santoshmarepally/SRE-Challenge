# use this for HTTPS
# data "aws_acm_certificate" "selected" {
#   domain = "*.sre.com"
# }


#---------------Load Balancer----------------------------

resource "aws_alb" "application_load_balancer" {
  name               = "sre-lb" 
  load_balancer_type = "application"
  subnets = [ 
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]

  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

#------------------------- Target Group -----------------------------------------
resource "aws_lb_target_group" "target_group" {
  name        = "sre-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.default_vpc.id}"
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" 
  port              = "80"   #change to 443 for secure transfer
  protocol          = "HTTP" #chane to HTTPS
#   ssl_policy        = "ELBSecurityPolicy-2016-08"             #uncomment for HTTPS
#   certificate_arn   = data.aws_acm_certificate.selected.arn   #uncomments for HTTPS

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" 
  }
}