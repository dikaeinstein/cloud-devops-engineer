module "sec_group" {
  source = "../sec-group"

  name        = "code-server"
  description = "Enables HTTP(S) and SSH access to code-server EC2 instance"
  vpc_id      = "vpc-06debb5a52dce2a37"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["105.112.182.70/32"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["105.112.182.70/32"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["105.112.182.70/32"]
    },
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = {
    Name  = "CodeServerSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "instance" {
  source = "../ec2"

  ami                    = "ami-0917237b4e71c5759" # Ubuntu 20.04 LTS
  instance_type          = "t2.micro"
  instance_count         = 1
  key_name               = "CodeServerKey"
  subnet_ids             = ["subnet-0373cef70584e126f"]
  vpc_security_group_ids = [module.sec_group.id]
  user_data              = file("${path.module}/bootstrap.sh")

  ebs_block_device = [
    {
      device_name = "/dev/sdk"
      volume_size = 20
    }
  ]

  tags = {
    Name  = "CodeServer"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}
