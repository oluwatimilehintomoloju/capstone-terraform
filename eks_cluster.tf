


data "aws_subnet" "public_subnet" {
  vpc_id                  = "vpc-078588c826ff3e876"  # Specify your VPC ID
  availability_zone       = "eu-west-2a"    # Specify your desired availability zone
  filter {
    name   = "tag:Name"
    values = ["bkss-public-subnet-eu-west-2a"]            # Specify the tag value of your public subnet
  }
}

# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.27"

  vpc_config {
    // TODO - Use terraform datasource to lookup existing public subnet id
    subnet_ids = [data.aws_subnet.public_subnet.id] #["subnet-07771b22ea9742877"]
        // TODO - Add security group ID here
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    // Todo - Update after Timilehin has added AmazonEKSServicePolicy
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
]
}