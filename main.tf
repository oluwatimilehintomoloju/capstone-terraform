resource "aws_s3_bucket" "terraform_state" {
  bucket = "bkss-tf"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "bkss-tf-dynamod-block"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_ecr_repository" "repo-1" {
    count = 2
    name = var.names[count.index]
    

    image_scanning_configuration {
        scan_on_push = true
    }

}

# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "capstone-eks-cluster" 
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.27" 

  vpc_config {
    subnet_ids =  "subnet-07771b22ea9742877"    #  bkss-public-subnet-eu-west-2a     [aws_subnet.eks_subnet.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_policy_attachment,
  ]
}
