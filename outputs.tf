output "bedrock_agentic_ds_team_id" {
  description = "The ID of the Bedrock Agentic Data Science team."
  value       = module.bedrock_agentic_ds_team.team_id
}

output "s3_bucket_name" {
  description = "S3 bucket for data science artifacts."
  value       = module.bedrock_agentic_ds_team.s3_bucket_name
}
