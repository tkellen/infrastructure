resource "aws_iam_policy" "ses" {
  name = "ses"
  path = "/shared/ses/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ses:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
