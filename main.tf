terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "backend-bucket" {
  bucket = "ejf-terraform-state"

  object_lock_enabled = "false"

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

#resource "aws_s3_bucket_object_lock_configuration" "backend-olc" {
#  bucket = aws_s3_bucket.backend-bucket.id
#
#  rule {
#    default_retention {
#      mode = "COMPLIANCE"
#      days = 1
#    }
#  }
#}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend-sse" {
  bucket = aws_s3_bucket.backend-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "backend-versioning" {
  bucket = aws_s3_bucket.backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "backend-dynamodb" {
  name           = "ejf-terraform-state-table"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}
