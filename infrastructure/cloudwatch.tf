
resource "aws_cloudwatch_event_rule" "ec_shutdown" {
  name        = "event_ec_shutdown"
  description = "Shutdown EC machines automatically every day at 23.59, so to avoid unexpected billing"

  schedule_expression = "cron(59 23 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda-ec-shutdown" {
  arn  = ""
  rule = aws_cloudwatch_event_rule.ec_shutdown.name
}
