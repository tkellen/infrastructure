module "iam" {
  source = "../../modules/aws/iam"
  name = "${var.name}"
  existing-policy-arns = []
  create-policy-names = [
    "full-bucket-rights"
  ]
  create-policy-documents = [
    "${data.template_file.full-bucket-rights.rendered}"
  ]
}

data "template_file" "full-bucket-rights" {
  template = "${file("${path.module}/../../templates/aws/full-bucket-rights.tpl")}"
  vars {
    bucket = "${aws_s3_bucket.main.id}"
  }
}
