resource "aws_eks_node_group" "eks_worker_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  subnet_ids = [data.aws_subnet.public_subnet.id]
  node_group_name = aws_iam_role.node_role.name
  node_role_arn   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  /*launch_template {
    id      = "<launch_template_id>"
    version = "$Latest"
  }*/
}