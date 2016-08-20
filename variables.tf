variable "name" {
  description = "The name of the cluster"
  type        = "string"
}

variable "env" {
  description = "The environment of the cluster"
  default     = ""
  type        = "string"
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster is running on"
  type        = "string"
}

variable "bastion_sg_id" {
  description = "The security group of the bastion"
  type        = "string"
}

variable "aws_key_name" {
  description = "The AWS key name for the master nodes"
  type        = "string"
}

variable "count" {
  description = "The number of etcd nodes"
  default     = 5
  type        = "string"
}

variable "ami" {
  description = "The AMI for the etcd nodes"
  type        = "string"
}

variable "flannel_cidr" {
  description = "The CIDR for the flannel network"
  default     = "10.2.0.0/16"
  type        = "string"
}

variable "instance_type" {
  description = "The instance type for the etcd nodes"
  default     = "m3.medium"
  type        = "string"
}

variable "subnet_ids" {
  description = "A list of subnet ids for the etcd nodes. It's recommanded to host the ETCD server on a private subnet."
  type        = "list"
}

variable "discovery_url" {
  description = "etcd2 discovery url. Use `make discovery_url` to generate a new one"
  type        = "string"
}

variable "disable_api_termination" {
  description = "Enable EC2 Termination protection"
  default     = true
}
