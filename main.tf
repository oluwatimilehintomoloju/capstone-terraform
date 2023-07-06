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
