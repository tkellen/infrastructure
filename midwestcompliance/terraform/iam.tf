resource "aws_iam_policy" "ses" {
  name = "${var.name}-ses"
  path = "/${var.name}/ses/"
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

resource "aws_iam_policy" "bucket" {
  name = "${var.name}-bucket"
  path = "/${var.name}/bucket/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}*"
      ]
    }
  ]
}
EOF
}

##
# Create role to receive permissions.
#
resource "aws_iam_role" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"AWS": "*"},
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

##
# Create user to receive permissions.
#
resource "aws_iam_user" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
}

##
# Attach policies to user.
#
resource "aws_iam_user_policy_attachment" "ses" {
  user = "${aws_iam_user.main.id}"
  policy_arn = "${aws_iam_policy.ses.arn}"
}
resource "aws_iam_user_policy_attachment" "bucket" {
  user = "${aws_iam_user.main.id}"
  policy_arn = "${aws_iam_policy.bucket.arn}"
}

##
# Create instance profile / link to role (for associating with ec2 instances).
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
  role = "${aws_iam_role.main.name}"
}
