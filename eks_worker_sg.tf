resource "aws_security_group" "eks_worker_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for the worker nodes in the cluster"
  vpc_id      = "vpc-078588c826ff3e876"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "self" {
  description              = "Allow worker nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  to_port                  = 65535
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_worker_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id
}

resource "aws_security_group_rule" "worker_from_master_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker_ingress_master_cluster_to_others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "master_cluster_ingress_worker" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id
  to_port                  = 443
  type                     = "ingress"
}