resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.project_name}/${var.environment_name}"
  retention_in_days = 60

  tags = {
    Name = "${var.project_name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.project_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

 # Capture the event change - example: ECS Task status
resource "aws_cloudwatch_event_rule" "ecs_check_rule" { 
  name        = "sre-ecs-check-rule"
  description = "capture ecs check"

#Event patterns  -- ["aws.ecs"], ["aws.elasticloadbalancing"]  
  event_pattern = <<EOF
{
   "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Task State Change",
    "ECS Container Instance State Change"
  ]           
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.ecs_check_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ecs_check_topic.arn
}