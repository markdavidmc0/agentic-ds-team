output "raw_data_bucket_name" {
  value = google_storage_bucket.raw_data.name
}

output "processed_data_bucket_name" {
  value = google_storage_bucket.processed_data.name
}

output "bigquery_dataset_id" {
  value = google_bigquery_dataset.fraud_features.dataset_id
}
