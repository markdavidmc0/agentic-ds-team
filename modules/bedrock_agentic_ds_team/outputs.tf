# outputs.tf for Bedrock Agentic DS Team module
output "team_id" {
  description = "The ID of the Bedrock Agentic DS team."
  value       = aws_bedrock_agentic_team.this.id
}

output "s3_bucket_name" {
  description = "S3 bucket for data science artifacts."
  value       = var.s3_bucket_name
}

output "sagemaker_endpoint_name" {
  description = "The name of the SageMaker endpoint for fraud classifier inference."
  value       = aws_sagemaker_endpoint.fraud_classifier.name
}

output "fraud_data_bucket_name" {
  description = "S3 bucket name for fraud data in Parquet format."
  value       = aws_s3_bucket.fraud_data.bucket
}

output "data_agent_role_arn" {
  description = "IAM role ARN for the data agent to access S3 Parquet data."
  value       = aws_iam_role.data_agent.arn
}
