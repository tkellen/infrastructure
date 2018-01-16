output "name" {
  value = "${var.name}"
}

output "controlplane-hostnames" {
  value = "${aws_instance.controlplane.*.tags.Name}"
}

output "controlplane-ssh-ips" {
  value = "${aws_instance.controlplane.*.public_ip}"
}

output "controlplane-private-ips" {
  value = "${aws_instance.controlplane.*.private_ip}"
}

output "etcd-hostnames" {
  value = "${aws_instance.etcd.*.tags.Name}"
}

output "etcd-ssh-ips" {
  value = "${aws_instance.etcd.*.public_ip}"
}

output "etcd-private-ips" {
  value = "${aws_instance.etcd.*.private_ip}"
}

output "worker-ssh-ips" {
  value = "${aws_instance.worker.*.public_ip}"
}

output "worker-private-ips" {
  value = "${aws_instance.worker.*.private_ip}"
}

output "worker-hostnames" {
  value = "${aws_instance.worker.*.tags.Name}"
}

output "public-ip" {
  value = "${aws_eip.loadbalancer.public_ip}"
}
