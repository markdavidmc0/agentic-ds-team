# Terraform configuration to create an S3 bucket with a valid name

provider "aws" {
  region = "us-east-1"
  # Consider using a dedicated IAM user/role with least privilege for Terraform
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-arch-to-iac-2025" # Must be globally unique and follow S3 naming rules
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
