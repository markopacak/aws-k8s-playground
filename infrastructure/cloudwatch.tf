
resource "aws_cloudwatch_event_rule" "ec-shutdown" {
  name = "cw-ec-shutdown"
  description = "Shutdown EC machines automatically every day at 23.59, so to avoid unexpected billing"

  schedule_expression = "cron(59 23 * * *)"
}
