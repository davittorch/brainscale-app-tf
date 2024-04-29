locals {
  name        = "brainscale-app-tf"
  aws_account = "211125651847"
  aws_region  = "us-east-1"
  aws_profile = "intern"
  ecr_reg     = "${local.aws_account}.dkr.ecr.${local.aws_region}.amazonaws.com"
  ecr_repo    = "brainscale-app-tf"
  image_tag   = "latest"
}
