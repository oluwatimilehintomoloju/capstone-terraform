data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks_cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}


data "aws_vpc" "bkss-capstone" {
  filter {
    name = "tag:Name"
    values = ["bkss-capstone"]
  }
}

data "aws_subnet" "public_subnet" {

  vpc_id            = data.aws_vpc.bkss-capstone.id
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


