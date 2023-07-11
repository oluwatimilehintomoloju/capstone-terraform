resource "aws_iam_role" "node_role" {
    name = var.node_group_name

    assume_role_policy = jsonencode ({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })

}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCorePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    role = aws_iam_role.node_role.name
}


resource "aws_iam_instance_profile" "eks_profile" {
    name = var.iam_profile_name
    role = aws_iam_role.node_role.name
}
