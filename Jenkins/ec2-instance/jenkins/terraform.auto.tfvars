env = "dev"
name = "jenkins"
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

trusted_role_services = ["ec2.amazonaws.com"]
custom_role_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]


http_sg_description = "HTTP Security group for Bastion EC2 instance"
http_ingress_cidr_blocks = ["0.0.0.0/0"]
http_ingress_rules = ["http-8080-tcp"]
http_egress_rules = ["all-all"]
