# SageMaker model training and deployment for fraud binary classifier

resource "aws_sagemaker_model" "fraud_classifier" {
  name               = var.sagemaker_model_name
  execution_role_arn = var.sagemaker_execution_role_arn
  primary_container {
    image          = var.sagemaker_image
    model_data_url = var.model_artifact_s3_uri
    environment = {
      SAGEMAKER_PROGRAM = var.sagemaker_entry_point
      SAGEMAKER_REGION  = var.aws_region
    }
  }
  enable_network_isolation = true # Prevents model container from making outbound network calls
  tags                     = var.tags
}

resource "aws_sagemaker_endpoint_configuration" "fraud_classifier" {
  name = "${var.sagemaker_model_name}-endpoint-config"
  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.fraud_classifier.name
    initial_instance_count = 1
    instance_type          = var.sagemaker_instance_type
  }
  kms_key_arn = var.sagemaker_kms_key_arn # Optional: Use KMS for endpoint encryption if provided
  tags        = var.tags
}

resource "aws_sagemaker_endpoint" "fraud_classifier" {
  name                 = "${var.sagemaker_model_name}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.fraud_classifier.name
  tags                 = var.tags
  # Optionally restrict access using VPC or endpoint policies for least privilege
}

variable "sagemaker_kms_key_arn" {
  description = "KMS key ARN for encrypting SageMaker endpoint data."
  type        = string
  default     = null
}
