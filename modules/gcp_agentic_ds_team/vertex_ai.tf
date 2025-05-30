# Google Vertex AI Model and Endpoint for Fraud Binary Classifier
resource "google_vertex_ai_model" "fraud_classifier" {
  display_name = var.gcp_vertex_model_display_name
  container_spec {
    image_uri = var.gcp_vertex_model_image
    command   = var.gcp_vertex_model_command
    args      = var.gcp_vertex_model_args
    env       = var.gcp_vertex_model_env
  }
  artifact_uri = var.gcp_vertex_model_artifact_gcs_uri
  labels       = var.gcp_labels
}

resource "google_vertex_ai_endpoint" "fraud_classifier" {
  display_name = "fraud-binary-classifier-endpoint"
  labels       = var.gcp_labels
}

resource "google_vertex_ai_endpoint_deployment" "fraud_classifier_deployment" {
  endpoint     = google_vertex_ai_endpoint.fraud_classifier.id
  model        = google_vertex_ai_model.fraud_classifier.id
  deployed_model_display_name = "fraud-binary-classifier"
  traffic_split = { "0" = 100 }
}
