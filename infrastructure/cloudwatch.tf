
resource "aws_cloudwatch_event_rule" "ec_shutdown" {
  count = var.ec_automatic_shutdown ? 1 : 0

  name        = "event_ec_shutdown"
  description = "Shutdown EC machines automatically every day at 23.59, so to avoid unexpected billing"

  schedule_expression = "cron(59 23 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda-ec-shutdown" {
  count = var.ec_automatic_shutdown ? 1 : 0

  arn  = aws_lambda_function.ec_shutdown[0].arn
  rule = aws_cloudwatch_event_rule.ec_shutdown[0].name
}
