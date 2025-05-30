# Terraform module for AWS Bedrock Agentic Data Science Team
# This module provisions resources for a team that manages the full DS lifecycle for fraud binary classifiers

module "bedrock_agentic_ds_team" {
  source = "aws-ia/bedrock/aws"
  # Team and agent configuration
  team_name   = "fraud-ds-agentic-team"
  description = "Agentic Data Science team for end-to-end fraud binary classifier lifecycle."

  # Agentic team capabilities
  capabilities = [
    "data-discovery",
    "feature-engineering",
    "model-training",
    "model-evaluation",
    "experiment-tracking",
    "model-deployment"
  ]

  # Model type and use case
  model_type = "binary-classifier"
  use_case   = "fraud-detection"

  # (Optional) S3 bucket for data and artifacts
  s3_bucket_name = module.s3_bucket.bucket_name
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "fraud-ds-agentic-artifacts-${random_id.suffix.hex}"
  acl    = "private"
}

resource "random_id" "suffix" {
  byte_length = 4
}
