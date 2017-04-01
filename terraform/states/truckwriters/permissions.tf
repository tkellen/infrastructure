##
# Grant access to the storage bucket.
#
resource "aws_iam_policy" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
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
    },
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

##
# A role to receive permissions from the IAM policy system.
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
# Attach policy to role.
#
resource "aws_iam_role_policy_attachment" "main" {
  role = "${aws_iam_role.main.name}"
  policy_arn = "${aws_iam_policy.main.arn}"
}

##
# Create instance profile to associate with compute instances.
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
  roles = ["${aws_iam_role.main.name}"]
}
