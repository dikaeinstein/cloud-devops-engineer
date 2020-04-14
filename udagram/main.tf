module "network" {
  source = "../vpc"

  create_igw         = true
  enable_nat_gateway = true
  environment_name   = "Udagram"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24"]
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

  egress_rules = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = {
    Name  = "UdagramBastionSecGroup"
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
    Name  = "UdagramLBSecGroup"
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
    Name  = "UdagramWebAppSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

resource "aws_iam_instance_profile" "webapp" {
  role = "UdacityS3ReadOnlyEC2"
}

resource "aws_launch_configuration" "webapp" {
  image_id             = "ami-0ed2df11a6d41ea78"
  iam_instance_profile = aws_iam_instance_profile.webapp.name
  instance_type        = "t3.medium"
  security_groups      = [module.webapp_sec_group.id]
  key_name             = "UdagramWebAppKey"

  ebs_block_device {
    device_name = "/dev/sdk"
    volume_size = 10
  }

  user_data = templatefile("${path.module}/bootstrap.sh", {})

  lifecycle {
    create_before_destroy = true
  }
}

module "webapp_lb" {
  source = "../alb"

  name             = "WebAppLB"
  environment_name = "Udagram"
  security_groups  = [module.lb_sec_group.id]
  subnets          = module.network.public_subnets
  vpc_id           = module.network.vpc_id

  target_groups = [
    {
      backend_port     = 80
      backend_protocol = "HTTP"
      health_check = {
        interval            = 10
        path                = "/"
        protocol            = "HTTP"
        timeout             = 8
        healthy_threshold   = 3
        unhealthy_threshold = 5
      }
    }
  ]

  listeners = [
    {
      protocol = "HTTP"
      port     = 80
    }
  ]

  tags = {
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

resource "aws_lb_listener_rule" "webapp" {
  listener_arn = module.webapp_lb.listener_arns[0]
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = module.webapp_lb.target_group_arns[0]
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_autoscaling_group" "webapp" {
  launch_configuration = aws_launch_configuration.webapp.id

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  target_group_arns   = module.webapp_lb.target_group_arns
  vpc_zone_identifier = module.network.private_subnets

  tags = [
    {
      key                 = "Scope",
      value               = "UdacityCloudDevopsEngineerNanodegree"
      propagate_at_launch = true
    }
  ]
}

module "webapp_cpu_alarm_high" {
  source = "../sns"

  display_name = "HighCPUUtilizationAlarmTopic"
}

resource "aws_cloudwatch_metric_alarm" "webapp" {
  alarm_name          = "CPUAlarmHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp.name
  }

  alarm_description = "Notify me if CPU utilization is greater than 90% for 10 minute"
  alarm_actions     = [module.webapp_cpu_alarm_high.arn]
}
