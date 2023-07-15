data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks_cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

data "aws_subnet" "public_subnet" {
  // TODO - Change this to data lookup of VPC ID
  vpc_id            = "vpc-078588c826ff3e876"
  availability_zone = var.az
  filter {
    name   = "tag:Name"
    values = ["bkss-${var.subnet_type}-subnet-${var.az}"]
  }
}

data "http" "workstation_external_ip" {
  url = "https://ipv4.icanhazip.com/"
}

data "aws_region" "current" {}