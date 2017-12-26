##
# Create all provided inline policies.
#
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
# Attach all existing policies to role.
#
resource "aws_iam_role_policy_attachment" "existing" {
  count = "${length(var.existing-policy-arns)}"
  role = "${aws_iam_role.main.id}"
  policy_arn = "${element(var.existing-policy-arns, count.index)}"
}

##
# Attach all inline created policies to role.
#
resource "aws_iam_role_policy_attachment" "inline" {
  role = "${aws_iam_role.main.id}"
  policy_arn = "${aws_iam_policy.bucket.arn}"
}

##
# Create user to receive permissions.
#
resource "aws_iam_user" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
}

##
# Attach all existing policies to user.
#
resource "aws_iam_user_policy_attachment" "existing" {
  count = "${length(var.existing-policy-arns)}"
  user = "${aws_iam_user.main.id}"
  policy_arn = "${element(var.existing-policy-arns, count.index)}"
}

resource "aws_iam_user_policy_attachment" "existing" {
  count = "${length(var.existing-policy-arns)}"
  user = "${aws_iam_user.main.id}"
  policy_arn = "${element(var.existing-policy-arns, count.index)}"
}



##
# Create instance profile / link to role (for associating with ec2 instances).
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
  roles = ["${aws_iam_role.main.name}"]
}
