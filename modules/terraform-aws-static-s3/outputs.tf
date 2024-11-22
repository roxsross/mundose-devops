output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

# Output the website endpoint
output "website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
}

output "bucket_regional_domain_name" {
  description = "S3 bucket regional domain name"
  value       = aws_s3_bucket.example.bucket_regional_domain_name
}