resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS cluster for Cluster communication with worker nodes"

  vpc_id      = data.aws_vpc.bkss-capstone.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}


#           Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com or whatsmyip can help you find this.
resource "aws_security_group_rule" "ingress-workstation-https" {
  cidr_blocks       = [local.workstation_external_cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  type              = "ingress"
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster_sg.id
  to_port           = 443
}