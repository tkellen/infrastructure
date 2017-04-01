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
# Note: this accepts the risk of hosting in single AZ.
#
resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_cidr_block}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.name}"
  }
}

##
# Configure ACL to allow all inbound and outbound traffic. Further access
# control is managed by security groups.
#
resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.main.id}"]
  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  tags {
    Name = "${var.name}"
  }
}

##
# Create a gateway to the internet.
#
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}"
  }
}

##
# Create a route table for public subnets.
#
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}"
  }
}

##
# Create an entry in each of our route tables that provides internet access
# via the gateway defined above.
#
resource "aws_route" "main" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

##
# Associate route tables with subnet.
#
resource "aws_route_table_association" "main" {
  subnet_id = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

##
# Allow access on web ports only.
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
