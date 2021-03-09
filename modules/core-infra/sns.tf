resource "aws_sns_topic" "ecs_check_topic" {
  name = "sre-ecs-check-topic"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.ecs_check_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.ecs_check_topic.arn]
  }
}