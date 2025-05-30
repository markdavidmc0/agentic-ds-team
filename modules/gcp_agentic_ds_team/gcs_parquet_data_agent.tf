# Google Cloud Storage bucket for fraud data (parquet)
resource "google_storage_bucket" "fraud_data" {
  name                        = var.gcp_fraud_data_bucket_name
  location                    = var.gcp_location
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = var.gcp_kms_key_name
  }
  labels = var.gcp_labels
}

resource "google_storage_bucket_object" "fraud_data_parquet" {
  for_each     = fileset(var.gcp_fraud_data_local_dir, "*.parquet")
  name         = each.value
  bucket       = google_storage_bucket.fraud_data.name
  source       = "${var.gcp_fraud_data_local_dir}/${each.value}"
  content_type = "application/octet-stream"
}
