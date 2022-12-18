resource "aws_lambda_function" "ec_shutdown" {
  count = local.automatic_shutdown ? 1 : 0

  function_name = "lambda_ec_shutdown"
  role          = aws_iam_role.ec_shutdown[0].arn

  runtime = "python3.9"
  handler = "lambda_function.lambda_handler"

  filename = "${path.root}/infrastructure/out/zip/lambda.zip"
}

data "archive_file" "lambda_shutdown_zip" {
  count = local.automatic_shutdown ? 1 : 0

  type        = "zip"
  output_path = "${path.root}/infrastructure/out/zip/lambda.zip"

  source {
    content  = file("${path.root}/../src/lambda_cloudwatch_ec_shutdown/lambda.py")
    filename = "lambda_function.py"
  }
}
