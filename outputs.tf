output "private_ips" {
  value = ["${aws_instance.etcd.*.private_ip}"]
}

output "public_ips" {
  value = ["${aws_instance.etcd.*.public_ip}"]
}
