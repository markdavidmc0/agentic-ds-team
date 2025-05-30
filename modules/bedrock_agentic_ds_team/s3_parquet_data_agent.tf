# Terraform module for S3 Parquet data source and Data Agent IAM role

resource "aws_s3_bucket" "fraud_data" {
  bucket        = var.fraud_data_bucket_name
  acl           = "private"
  force_destroy = true
  tags          = var.tags

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

resource "aws_s3_bucket_object" "fraud_data_parquet" {
  for_each     = fileset(var.fraud_data_local_dir, "*.parquet")
  bucket       = aws_s3_bucket.fraud_data.id
  key          = each.value
  source       = "${var.fraud_data_local_dir}/${each.value}"
  etag         = filemd5("${var.fraud_data_local_dir}/${each.value}")
  content_type = "application/octet-stream"
}

resource "aws_iam_role" "data_agent" {
  name                 = "fraud-data-agent-role"
  assume_role_policy   = data.aws_iam_policy_document.data_agent_assume.json
  tags                 = var.tags
  max_session_duration = 3600                             # Limit session duration to 1 hour
  permissions_boundary = var.iam_permissions_boundary_arn # Optional: enforce permissions boundary if provided
}

data "aws_iam_policy_document" "data_agent_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com", "sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "data_agent_s3" {
  name        = "fraud-data-agent-s3-access"
  description = "Allow data agent to read/write Parquet data in S3 bucket."
  policy      = data.aws_iam_policy_document.data_agent_s3.json
  tags        = var.tags # Add tags for traceability
  # Consider using resource-level conditions for least privilege
}

data "aws_iam_policy_document" "data_agent_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.fraud_data.arn,
      "${aws_s3_bucket.fraud_data.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "data_agent_s3" {
  role       = aws_iam_role.data_agent.name
  policy_arn = aws_iam_policy.data_agent_s3.arn
}

variable "iam_permissions_boundary_arn" {
  description = "ARN of the IAM permissions boundary policy to attach to roles for least privilege."
  type        = string
  default     = null
}
