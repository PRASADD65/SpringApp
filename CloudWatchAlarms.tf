# Log Metric Filter for Errors ------
resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "spring-error-filter"
  log_group_name = "spring-app-logs"
  pattern        = "\"ERROR\" || \"Exception\""

  metric_transformation {
    name      = "SpringAppErrorCount"
    namespace = "SpringApp"
    value     = "1"
  }
}

# Alarm on Error Count -------
resource "aws_cloudwatch_metric_alarm" "spring_error_alarm" {
  alarm_name          = "SpringAppErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SpringAppErrorCount"
  namespace           = "SpringApp"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Spring app logs contain errors"
  alarm_actions       = [aws_sns_topic.app_alerts.arn]
}

# Alarm on EC2 Instance Status ------------
resource "aws_cloudwatch_metric_alarm" "instance_status_alarm" {
  alarm_name          = "EC2InstanceStatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Alarm when EC2 instance status check fails"
  alarm_actions       = [aws_sns_topic.app_alerts.arn]
  dimensions = {
    InstanceId = aws_instance.spring_app.id
  }
}






















