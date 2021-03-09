resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.sre_ecs_cluster.name}/${aws_ecs_service.sre_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.project_name}_${var.environment_name}_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.sre_ecs_cluster.name}/${aws_ecs_service.sre_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.project_name}_${var.environment_name}_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.sre_ecs_cluster.name}/${aws_ecs_service.sre_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }

  }

  depends_on = [aws_appautoscaling_target.target]
}
