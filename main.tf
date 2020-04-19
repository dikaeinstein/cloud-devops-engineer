module "s3_state_backend" {
  source = "./s3-backend"

  bucket_name       = "cde-nanodegree-infra-tfstate"
  dynamo_table_name = "cde-nanodegree-infra-tfstate-lock"
  tag_name          = "UdacityCloudDevopsEngineerNanodegree"
}

# module "static_site" {
#   source = "./static-site"
# }

# module "udagram" {
#   source = "./udagram"
# }

module "jenkins" {
  source = "./jenkins"
}
