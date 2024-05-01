resource "aws_key_pair" "app_key" {
  key_name   = "${var.name_prefix}-key"
  public_key = var.public_key
}

resource "aws_launch_template" "app_template" {
  name = "${var.name_prefix}-lt"

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true
  ebs_optimized           = true

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.app_key.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-instance"
    }
  }

  user_data = var.user_data
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.name_prefix}-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  depends_on = [var.asg_depends_on]
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = var.lb_target_group_arn
}
