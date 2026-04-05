provider "aws" {
  region = "eu-central-1"
}

#S3 Bucket
resource "aws_s3_bucket" "state_bucket" {
  bucket = "aws-mihai-titan-bucket"
}

#Versioning S3 bucket
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#The LOCK ( DynamoDB Table)
resource "aws_dynamodb_table" "terraform_lock" {
  name = "aws-mihai-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


