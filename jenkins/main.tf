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
      cidr_blocks = ["105.112.153.73/32"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["105.112.153.73/32"]
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
  user_data              = file("${path.module}/bootstrap.sh")

  ebs_block_device = [
    {
      device_name = "/dev/sdk"
      volume_size = 20
    }
  ]

  tags = {
    Name  = "JenkinsNode"
    Scope = "UdacityCloudDevopsEngineerNanodegree"
  }
}

# module "static_pipeline" {
#   source = "../s3"

#   acl         = "public-read"
#   bucket_name = "dika-static-jenkins-pipeline"
#   policy_path = "${path.module}/roles/static-pipeline.json"
#   tag_name    = "JenkinsStaticPipeline"
#   tags        = { Scope = "UdacityCloudDevopsEngineerNanodegree" }

#   website = {
#     index_document = "index.html"
#   }
# }
