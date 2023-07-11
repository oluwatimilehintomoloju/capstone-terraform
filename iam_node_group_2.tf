resource "aws_iam_role_policy_attachment" "WorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "EKS_CNIPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "EC2CR_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_role.name
}



