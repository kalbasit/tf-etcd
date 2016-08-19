resource "aws_security_group" "etcd" {
  name_prefix = "etcd-"
  description = "The security group for the ETCD nodes"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    EtcdCluster = "${var.name}"
    role        = "etcd"
    env         = "${var.env}"
  }
}

resource "aws_security_group_rule" "etcd-allow-all-icmp-out" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-all-tcp-out" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-all-udp-out" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-all-icmp-in" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-ssh-from-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${var.bastion_sg_id}"
  security_group_id        = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-etcd-peer-from-all" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 2380
  to_port           = 2380
  protocol          = "tcp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-etcd-from-all" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 2379
  to_port           = 2379
  protocol          = "tcp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-flannel-from-all" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8472
  to_port           = 8472
  protocol          = "udp"
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcd-allow-all-from-self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = "${aws_security_group.etcd.id}"
}

resource "aws_instance" "etcd" {
  count                   = "${var.count}"
  ami                     = "${var.ami}"
  user_data               = "${data.template_file.etcd-cloud-config.rendered}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.aws_key_name}"
  subnet_id               = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids  = ["${aws_security_group.etcd.id}"]
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
