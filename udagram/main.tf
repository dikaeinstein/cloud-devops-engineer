module "network" {
  source = "../vpc"

  create_igw         = true
  enable_nat_gateway = true
  environment_name   = "Udagram"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet      = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets    = ["10.0.2.0/24", "10.0.3.0/24"]
  tags = {
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "bastion_sec_group" {
  source = "../sec-group"

  description = "Enables SSH Access to the Bastion Host"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = {
    Name  = "BastionSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "bastion_host" {
  source = "../ec2"

  ami                    = "ami-0ed2df11a6d41ea78"
  instance_type          = "t2.micro"
  instance_count         = 1
  key_name               = "UdagramBastionKey"
  subnet_ids             = module.network.public_subnets
  vpc_security_group_ids = [module.bastion_sec_group.id]

  ebs_block_device = [
    {
      device_name = "/dev/sdk"
      volume_size = 10
    }
  ]

  tags = {
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

resource "aws_eip" "bastion_eip" {
  vpc      = true
  instance = module.bastion_host.ids[0]

  tags = {
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "lb_sec_group" {
  source = "../sec-group"

  description = "Enables HTTP Access to the load balancer"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = {
    Name  = "LBSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "webapp_sec_group" {
  source = "../sec-group"

  description = "Enables HTTP and SSH to our hosts"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
    Name  = "WebAppSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

resource "aws_iam_instance_profile" "webapp" {
  roles = ["UdacityS3ReadOnlyEC2"]
}

resource "aws_launch_configuration" "webapp" {
  image_id             = "ami-0ed2df11a6d41ea78"
  iam_instance_profile = aws_iam_instance_profile.webapp
  instance_type        = "t3.medium"
  security_groups      = [module.webapp_sec_group.id]
  key_name             = "UdagramWebAppKey"

  ebs_block_device = {
    device_name = "/dev/sdk"
    volume_size = 10
  }

  user_data = file("${module.path}./bootstrap.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webapp" {
  launch_configuration = aws_launch_configuration.webapp.id

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  target_group_arns =
  vpc_zone_identifier = module.network.private_subnets

  tags = [
    {
      Scope             = "UdacityCloudDevopsEngineerNanodegree"
      PropagateAtLaunch = true
    }
  ]
}
