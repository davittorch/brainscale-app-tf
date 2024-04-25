provider "aws" {
  region = "us-east-1"  
}

locals {
  name = "brainscale-app-tf"
  aws_account = "211125651847"
  aws_region  = "us-east-1"
  aws_profile = "intern"
  ecr_reg   = "${local.aws_account}.dkr.ecr.${local.aws_region}.amazonaws.com"
  ecr_repo  = "brainscale-app-tf"
  image_tag = "latest"
}

resource "null_resource" "build_push_dkr_img" {
  
  provisioner "local-exec" {
    command = "aws --profile ${local.aws_profile} ecr get-login-password --region ${local.aws_region} | docker login --username AWS --password-stdin ${local.ecr_reg}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${local.name} ../app"
  }

  provisioner "local-exec" {
    command = "docker tag ${local.name}:${local.image_tag} ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag}"
  }

  provisioner "local-exec" {
    command = "docker push ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag}"
  }

  depends_on = [ aws_ecr_repository.app ]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_ecr_repository" "app" {
  name                 = "${local.ecr_repo}"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_sg.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  enable_deletion_protection = false
}

resource "aws_key_pair" "app_key" {
  key_name   = "app-key-tf"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdQerMA+HrPYuQP4NRExGv7aseTYSlN/86n0Zi+pmGX7T2yjMgOACQh+kcEkdnK/TOtvLMCboW5Bov2fsRcM1hJaDuFywhoHTHGDAB1A2uIwukSiWmVEK5hntf+1EXMFEJ9ATLDR7aqmB/K8SEh4/6W9BwvnwyMzOv7pHBTCXgzYrZ82Up2OUtM3d9mcnUdFa/vuNZSs1IcZ6nF8JYQA9vdIlzICEdd749FZqzsIecwlL9Wh/PritUiitUqELSf4Gc1QNalI0L6IEIGegmrptoE7S9NgHQWk4MS8HqdUBTYm+p1ScrHuRAb9fhpoB34PDCpAM/jARZp7waxHFFn8annKsjINLUKh7MJWe1rollzXbYLqyWw9SJqaPd2I+gnn61sFyo2jrlD4tvzqBAWHzVcaXucaElCrm1GdRuGVgVX3Nj1OqNXizf3GKgXh4gEOh1qbimVQj5Q05f6Kd9Y7seX+cpRaIaTKGpKJsR5mrFfyPWAwrXv7uAzeKnBfS7fGVpPfh0H7ziCeqQw5kFF2rdATPksKnGSuDxL8VfghTPZOOCUBtsvEjSyDpp4wV2GTmWs2MtSgYvGPT1W/GoLMcq1IQt0wPzzqp8IJTVFZye3ahC9qECMrxcGKnHFJrSo1F3AFXKntcHp60G9a7Qb0kaERTd76bxmdJCMVv6kWkc0w== david@Torch"
}

resource "aws_lb_target_group" "lb-tg" {
  depends_on = [ aws_lb.app_lb ]
  name        = "lb-tg-tf"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/login"
    port                = 3000
    protocol            = "HTTP"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-499"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}

resource "aws_launch_template" "app_template" {
  name = "brainscale-app-lt-tf"

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.instance_sg.id, aws_security_group.loadbalancer_sg.id]
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true
  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_role.name
  }

  image_id = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  key_name = aws_key_pair.app_key.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "lt-tf"
    }
  }

  user_data = filebase64("./app-boot.sh")

  depends_on = [ null_resource.build_push_dkr_img ]
}

resource "aws_autoscaling_group" "app_asg" {
  name = "${local.name}-asg"
  vpc_zone_identifier = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  depends_on = [ aws_lb_target_group.lb-tg ]
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = aws_lb_target_group.lb-tg.arn

  depends_on = [ aws_autoscaling_group.app_asg ]
} 