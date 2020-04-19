module "sec_group" {
  source = "../sec-group"

  name        = "jenkins-nodes"
  description = "Enables HTTP and SSH access to jenkins nodes"
  vpc_id      = "vpc-06debb5a52dce2a37"

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["105.112.176.219/32"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["105.112.176.219/32"]
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
    Name  = "JenkinsSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "node" {
  source = "../ec2"

  ami                    = "ami-0ed2df11a6d41ea78"
  instance_type          = "t2.micro"
  instance_count         = 1
  key_name               = "JenkinsNodesKey"
  subnet_ids             = ["subnet-0373cef70584e126f"]
  vpc_security_group_ids = [module.sec_group.id]
  user_data = templatefile(
    "${path.module}/templates/bootstrap.tpl",
    { jenkins_version = "2.231" },
  )

  ebs_block_device = [
    {
      device_name = "/dev/sdk"
      volume_size = 10
    }
  ]

  tags = {
    Name  = "JenkinsNode"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}
