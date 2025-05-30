variable "gcp_fraud_data_bucket_name" {
  description = "GCS bucket name for raw fraud data."
  type        = string
  default     = "fraud-raw-data"

  validation {
    condition     = length(var.gcp_fraud_data_bucket_name) > 0
    error_message = "Bucket name must not be empty."
  }
}

variable "gcp_processed_data_bucket_name" {
  description = "GCS bucket name for processed fraud data."
  type        = string
  default     = "fraud-processed-data"

  validation {
    condition     = length(var.gcp_processed_data_bucket_name) > 0
    error_message = "Bucket name must not be empty."
  }
}

variable "gcp_location" {
  description = "GCP region for resources."
  type        = string
  default     = "europe-west2"
}

variable "gcp_labels" {
  description = "Labels for GCP resources."
  type        = map(string)
  default     = {
    team        = "fraud"
    environment = "dev"
  }
}

variable "organization_id" {
  description = "GCP organization ID."
  type        = string
}

variable "billing_account_id" {
  description = "GCP billing account ID."
  type        = string
}
