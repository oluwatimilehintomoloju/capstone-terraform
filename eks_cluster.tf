# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.27"

  vpc_config {
    // TODO - Use terraform datasource to lookup existing public subnet id
    subnet_ids = ["subnet-07771b22ea9742877"] #  bkss-public-subnet-eu-west-2a     [aws_subnet.eks_subnet.id]
    // TODO - Add security group ID here
    security_group_ids = []
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    // Todo - Update after Timilehin has added AmazonEKSServicePolicy
    //aws_iam_role_policy_attachment.eks_service_policy_attachment,
  ]
}