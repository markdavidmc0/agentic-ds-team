# variables.tf for Bedrock Agentic DS Team module
variable "team_name" {
  description = "Name of the Agentic Data Science team."
  type        = string
  default     = "fraud-ds-agentic-team"
}

variable "description" {
  description = "Description of the Agentic DS team."
  type        = string
  default     = "Agentic Data Science team for end-to-end fraud binary classifier lifecycle."
}

variable "capabilities" {
  description = "List of DS lifecycle capabilities."
  type        = list(string)
  default     = [
    "data-discovery",
    "feature-engineering",
    "model-training",
    "model-evaluation",
    "experiment-tracking",
    "model-deployment"
  ]
}

variable "model_type" {
  description = "Type of model (e.g., binary-classifier)."
  type        = string
  default     = "binary-classifier"
}

variable "use_case" {
  description = "Use case for the team (e.g., fraud-detection)."
  type        = string
  default     = "fraud-detection"
}

variable "s3_bucket_name" {
  description = "S3 bucket for data and artifacts."
  type        = string
  default     = null
}

variable "sagemaker_model_name" {
  description = "Name for the SageMaker model."
  type        = string
  default     = "fraud-binary-classifier"
}

variable "sagemaker_execution_role_arn" {
  description = "IAM role ARN for SageMaker execution."
  type        = string
}

variable "sagemaker_image" {
  description = "Container image URI for the model."
  type        = string
}

variable "model_artifact_s3_uri" {
  description = "S3 URI for the trained model artifact."
  type        = string
}

variable "sagemaker_entry_point" {
  description = "Entry point script for the model."
  type        = string
  default     = "inference.py"
}

variable "sagemaker_instance_type" {
  description = "Instance type for model serving."
  type        = string
  default     = "ml.m5.large"
}

variable "fraud_data_bucket_name" {
  description = "S3 bucket name for fraud data in Parquet format."
  type        = string
  default     = "fraud-data-parquet-bucket"
}

variable "fraud_data_local_dir" {
  description = "Local directory containing Parquet files to upload."
  type        = string
  default     = "./data"
}
