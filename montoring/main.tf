module "sec_group" {
  source = "../sec-group"

  name        = "monitoring"
  description = "Enables access to prometheus, node_exporter, grafana and nginx proxy to kibana."
  vpc_id      = "vpc-06debb5a52dce2a37"

  ingress_rules = [
    {
      description = "Enable access to prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Enable access to node_exporter"
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Enable access to grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Enable access to nginx proxy to kibana"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Enable SSH access"
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
    Name  = "MonitoringSecGroup"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

module "instance" {
  source = "../ec2"

  ami                    = "ami-0917237b4e71c5759" # Ubuntu 20.04 LTS
  instance_type          = "t2.medium"
  instance_count         = 1
  key_name               = "MonitoringKey"
  subnet_ids             = ["subnet-0373cef70584e126f"]
  vpc_security_group_ids = [module.sec_group.id]
  user_data              = file("${path.module}/bootstrap.sh")

  ebs_block_device = [
    {
      device_name = "/dev/sdk"
      volume_size = 40
    }
  ]

  tags = {
    Name  = "Monitoring"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}
