output "gcp_fraud_data_bucket_name" {
  description = "GCS bucket name for fraud data in Parquet format."
  value       = google_storage_bucket.fraud_data.name
}
