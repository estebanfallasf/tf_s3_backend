output "aws_s3_bucket_id" {
  value = resource.aws_s3_bucket.backend-bucket.id
}

output "aws_dynamodb_table_id" {
  value = resource.aws_dynamodb_table.backend-dynamodb.id
}
