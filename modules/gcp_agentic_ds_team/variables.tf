variable "gcp_fraud_data_bucket_name" {
  description = "GCS bucket name for fraud data in Parquet format."
  type        = string
  default     = "fraud-data-parquet-bucket"
}

variable "gcp_fraud_data_local_dir" {
  description = "Local directory containing Parquet files to upload."
  type        = string
  default     = "./data"
}

variable "gcp_location" {
  description = "GCP region/location for resources."
  type        = string
  default     = "us-central1"
}

variable "gcp_kms_key_name" {
  description = "KMS key name for GCS encryption."
  type        = string
  default     = null
}

variable "gcp_labels" {
  description = "Labels for GCP resources."
  type        = map(string)
  default     = {}
}

variable "gcp_vertex_model_display_name" {
  description = "Display name for Vertex AI model."
  type        = string
  default     = "fraud-binary-classifier"
}

variable "gcp_vertex_model_image" {
  description = "Container image URI for Vertex AI model."
  type        = string
}

variable "gcp_vertex_model_command" {
  description = "Command for Vertex AI model container."
  type        = list(string)
  default     = []
}

variable "gcp_vertex_model_args" {
  description = "Arguments for Vertex AI model container."
  type        = list(string)
  default     = []
}

variable "gcp_vertex_model_env" {
  description = "Environment variables for Vertex AI model container."
  type        = map(string)
  default     = {}
}

variable "gcp_vertex_model_artifact_gcs_uri" {
  description = "GCS URI for trained model artifact."
  type        = string
}
