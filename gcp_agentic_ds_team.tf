# Root module to deploy the Agentic Data Science team for fraud detection on GCP

module "gcp_agentic_ds_team" {
  source = "./modules/gcp_agentic_ds_team"

  # Example variable wiring (override as needed)
  gcp_fraud_data_bucket_name        = "fraud-data-parquet-bucket"
  gcp_fraud_data_local_dir          = "./data"
  gcp_location                      = "us-central1"
  gcp_vertex_model_display_name     = "fraud-binary-classifier"
  gcp_vertex_model_image            = var.gcp_vertex_model_image
  gcp_vertex_model_artifact_gcs_uri = var.gcp_vertex_model_artifact_gcs_uri
  gcp_vertex_model_command          = var.gcp_vertex_model_command
  gcp_vertex_model_args             = var.gcp_vertex_model_args
  gcp_vertex_model_env              = var.gcp_vertex_model_env
  gcp_labels                        = { Project = "FraudDetection", Environment = "Production" }
}
