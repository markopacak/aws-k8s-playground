data "aws_iam_policy_document" "ec_shutdown" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:*"]
  }
}

resource "aws_iam_role_policy" "ec_shutdown" {
  count = local.automatic_shutdown ? 1 : 0

  policy = data.aws_iam_policy_document.ec_shutdown.json
  role   = aws_iam_role.ec_shutdown[0].id
}


resource "aws_iam_role" "ec_shutdown" {
  count = local.automatic_shutdown ? 1 : 0

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}
