resource "aws_autoscaling_group" "worker_sg" {
  name                 = "capstone-eks-terraform-asg"
  vpc_zone_identifier  = [data.aws_subnet.public_subnet.id]
  launch_configuration = aws_launch_configuration.worker_lc.id
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
}

resource "aws_launch_configuration" "worker_lc" {
  associate_public_ip_address = var.associate_public_ip_address
  image_id                    = data.aws_ami.eks_worker.id
  instance_type               = var.instance_type
  name_prefix                 = var.organisation
  security_groups             = [aws_security_group.node_group_sg.id]
  user_data_base64            = base64decode(local.demo-node-userdata)
  iam_instance_profile        = aws_iam_instance_profile.eks_profile.name

  lifecycle {
    create_before_destroy = true
  }
}