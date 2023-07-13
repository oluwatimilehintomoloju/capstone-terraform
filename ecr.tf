resource "aws_ecr_repository" "repo-1" {
  count = 2
  name  = var.names[count.index]

  image_scanning_configuration {
    scan_on_push = true
  }
}