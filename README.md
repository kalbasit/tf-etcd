# tf-etcd
Terraform ETCD module

# Usage

```hcl
module "etcd" {
  source = "github.com/kalbasit/tf-etcd"

  aws_key_name  = "ec2-key-name"
  ami           = "ami-6d138f7a"
  discovery_url = "https://discovery.etcd.io/d3c6482aeb0154d904f3ca44ce986610"
  subnet_ids    = ["subnet-b73bc4f5"]
  sgs_ids       = [
    # out-pub allows instances to make connections to anywhere
    "${module.sgs.out-pub}",
    # in-self allows instances to contact each other on any protocol,
    # any port.
    "${module.sgs.in-self}",
  ]
}
```

# Module input variables

- `name` The name of the cluster
- `env` The environment of the cluster
- `vpc_id` The ID of the VPC where the cluster is running on
- `bastion_sg_id` The security group of the bastion
- `aws_key_name` The AWS key name for the master nodes
- `count` The number of etcd nodes
- `ami` The AMI for the etcd nodes
- `flannel_cidr` The CIDR for the flannel network
- `instance_type` The instance type for the etcd nodes
- `subnet_ids` A list of subnet ids for the etcd nodes. It's recommanded to host the ETCD server on a private subnet.
- `discovery_url` etcd2 discovery url. Use `make discovery_url` to generate a new one
- `disable_api_termination` Enable EC2 Termination protection

# Outputs

- `private_ips` A list of etcd private IPs
- `public_ips` A list of etcd public IPs
- `sg_id` The security group ID of the etcd nodes

# License

All source code is licensed under the [MIT License](LICENSE).
