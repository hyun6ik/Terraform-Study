env = "dev"
name = "bastion"
owner = "hyun6ik"
tags = {}

ami_owners = ["amazon"]
ami_filters = [
  {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
]

instance_type = "t2.micro"
key_name = "dev"

ssh_sg_description = "SSH Security group for Bastion EC2 instance"
ssh_ingress_cidr_blocks = ["116.39.225.234/32"]
ssh_ingress_rules = ["ssh-tcp"]
ssh_egress_rules = ["all-all"]