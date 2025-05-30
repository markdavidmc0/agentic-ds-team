output "gcp_fraud_data_bucket_name" {
  description = "GCS bucket name for fraud data in Parquet format."
  value       = google_storage_bucket.fraud_data.name
}

output "gcp_vertex_ai_endpoint_id" {
  description = "Vertex AI endpoint ID for fraud classifier inference."
  value       = google_vertex_ai_endpoint.fraud_classifier.id
}
