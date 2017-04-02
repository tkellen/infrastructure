##
# Create a virtual network to hold our application.
#
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.name}"
  }
}

##
# Create a single subnet for our network.
# Note: accepting the risk of hosting in single AZ.
#
module "subnet" {
  source = "../../modules/aws/subnet"
  name = "${var.name}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_blocks = ["${var.vpc_cidr_block}"]
  azs = "${data.aws_availability_zones.available.names}"
}

##
# Allow access on http/https only.
#
resource "aws_security_group" "main" {
  name = "${var.name}"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}"
  }
}
