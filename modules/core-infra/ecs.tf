
#---------------ECS Cluster----------------------------
resource "aws_ecs_cluster" "sre_ecs_cluster" {
  name = "sre-ecs-cluster" 
}

#---------------ECS Task Definition ----------------------------
resource "aws_ecs_task_definition" "sre_ecs_task" {
  family                   = "sre-ecs-task" 
  container_definitions    = <<DEFINITION
  [
    {
      "name": "sre-ecs-task",
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/sre-ecr-repo:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,                 
          "hostPort": 80                     
        }
      ],
      "memory": 512,
      "cpu": 256,
      "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log_group.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "${var.project_name}"
      }
    }

    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] 
  network_mode             = "awsvpc"    
  memory                   = 512         
  cpu                      = 256         
  execution_role_arn       = "${aws_iam_role.sre_ecs_task_role.arn}"
}

#---------------ECS Service----------------------------
resource "aws_ecs_service" "sre_ecs_service" {
  name            = "sre-ecs-service"                             
  cluster         = "${aws_ecs_cluster.sre_ecs_cluster.id}"             
  task_definition = "${aws_ecs_task_definition.sre_ecs_task.arn}" 
  launch_type     = "FARGATE"
  desired_count   = 2


    load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.id}" 
    container_name   = "${aws_ecs_task_definition.sre_ecs_task.family}"
    container_port   = 80             #80 
  }


    network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true 
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }

    depends_on = [
    aws_lb_listener.listener,
  ]
}   