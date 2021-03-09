#---------------Security Group for the Load Balancer----------------------------

resource "aws_security_group" "load_balancer_security_group" {
  name = "sre-alb-sg"
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

#---------------Security Group for the ECS Service----------------------------

resource "aws_security_group" "service_security_group" {
  name = "sre-ecs-service-sg"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}