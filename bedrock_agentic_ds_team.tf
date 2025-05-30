# Root module to deploy the Agentic Data Science team for fraud detection

module "bedrock_agentic_ds_team" {
  source = "./modules/bedrock_agentic_ds_team"

  agent_name            = "fraud-ds-agentic-team"
  agent_description     = "Agentic Data Science team for end-to-end fraud binary classifier lifecycle."
  foundation_model      = "anthropic.claude-v2"
  instruction           = "You are a collaborative team of data scientists and ML engineers. Your job is to take a user prompt describing a fraud binary classification experiment, perform data discovery, feature engineering, model training, evaluation, and deploy the best model. You must explain each step and output results."
  create_agent_alias    = true
  agent_alias_name      = "prod"
  create_default_kb     = true
  create_s3_data_source = true
  tags = {
    "Project"     = "FraudDetection"
    "Environment" = "Production"
  }

  # SageMaker module variables
  sagemaker_model_name         = "fraud-binary-classifier"
  sagemaker_execution_role_arn = var.sagemaker_execution_role_arn
  sagemaker_image              = var.sagemaker_image
  model_artifact_s3_uri        = var.model_artifact_s3_uri
  sagemaker_entry_point        = var.sagemaker_entry_point
  sagemaker_instance_type      = var.sagemaker_instance_type

  # S3 Parquet data agent module variables
  fraud_data_bucket_name = "fraud-data-parquet-bucket"
  fraud_data_local_dir   = "./data"
}
