resource "aws_instance" "etcd" {
  count                   = "${var.count}"
  ami                     = "${var.ami}"
  user_data               = "${data.template_file.etcd-cloud-config.rendered}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.aws_key_name}"
  subnet_id               = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids  = ["${var.sgs_ids}"]
  disable_api_termination = "${var.disable_api_termination}"

  tags {
    Name = "etcd-${count.index}"
    role = "etcd"
    env  = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "etcd-cloud-config" {
  template = "${file("${path.module}/templates/cloud-config.yml")}"

  vars {
    discovery_url = "${var.discovery_url}"
    flannel_cidr  = "${var.flannel_cidr}"
  }
}
