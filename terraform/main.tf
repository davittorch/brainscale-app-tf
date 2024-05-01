module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
}

module "iam_roles" {
  source                = "./modules/iam"
  role_name             = "EC2-role-tf"
  instance_profile_name = "EC2_profile"
}

module "security_groups" {
  source      = "./modules/sg"
  name_prefix = local.name
  vpc_id      = module.vpc.vpc_id
}

module "ecr_repository" {
  source          = "./modules/ecr"
  repository_name = local.ecr_repo
}

module "app_load_balancer" {
  source = "./modules/alb"

  name_prefix                = local.name
  internal                   = false
  security_group_id          = module.security_groups.loadbalancer_sg_id
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
  port                       = 3000
  vpc_id                     = module.vpc.vpc_id
  health_check_path          = "/login"
  listener_port              = 80
}

module "app_autoscaling" {
  source = "./modules/asg"

  name_prefix               = local.name
  security_group_ids        = [module.security_groups.instance_sg_id, module.security_groups.loadbalancer_sg_id]
  iam_instance_profile_name = module.iam_roles.iam_instance_profile_name
  image_id                  = module.app_load_balancer.image_id
  instance_type             = "t3.micro"
  user_data                 = filebase64("./app-boot.sh")
  subnet_ids                = module.vpc.public_subnets
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  asg_depends_on            = [module.app_load_balancer.target_group]
  lb_target_group_arn       = module.app_load_balancer.target_group_arn
}