data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks_cluster.id}-v*"]
  }

  most_recent = true
  owners = ["602401143452"]
}