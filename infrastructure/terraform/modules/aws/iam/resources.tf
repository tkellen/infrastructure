##
# Create all provided inline policies.
#
resource "aws_iam_policy" "inline" {
  count = "${length(var.create-policy-names)}"
  name = "${var.name}-${element(var.create-policy-names, count.index)}"
  path = "/${var.name}/${element(var.create-policy-names, count.index)}/"
  policy = "${element(var.create-policy-documents, count.index)}"
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
  count = "${length(var.create-policy-names)}"
  role = "${aws_iam_role.main.id}"
  policy_arn = "${element(aws_iam_policy.inline.*.arn, count.index)}"
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

##
# Attach all inline created policies to user.
#
resource "aws_iam_user_policy_attachment" "inline" {
  count = "${length(var.create-policy-names)}"
  user = "${aws_iam_user.main.id}"
  policy_arn = "${element(aws_iam_policy.inline.*.arn, count.index)}"
}

##
# Create instance profile / link to role (for associating with ec2 instances).
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  path = "/${var.name}/"
  roles = ["${aws_iam_role.main.name}"]
}
