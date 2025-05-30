terraform {
  backend "gcs" {
    bucket = "your-terraform-state-bucket"
    prefix = "gcp-agentic-ds-team"
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_location
}

resource "google_project" "fraud_detection" {
  name       = "my-fraud-detection-project"
  project_id = "my-fraud-detection-project"
  org_id     = var.organization_id
  billing_account = var.billing_account_id
}

resource "google_project_service" "enable_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "aiplatform.googleapis.com"
  ])
  service = each.key
  project = google_project.fraud_detection.project_id
}

resource "google_storage_bucket" "raw_data" {
  name                        = "fraud-raw-data-${google_project.fraud_detection.project_id}"
  location                    = "europe-west2"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_storage_bucket" "processed_data" {
  name                        = "fraud-processed-data-${google_project.fraud_detection.project_id}"
  location                    = "europe-west2"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_bigquery_dataset" "fraud_features" {
  dataset_id = "fraud_features_dataset"
  project    = google_project.fraud_detection.project_id
  location   = "europe-west2"
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_bigquery_table" "transactions_features" {
  table_id   = "transactions_features"
  dataset_id = google_bigquery_dataset.fraud_features.dataset_id
  project    = google_project.fraud_detection.project_id
  schema = jsonencode([
    { name = "transaction_id", type = "STRING", mode = "REQUIRED" },
    { name = "user_id", type = "STRING", mode = "REQUIRED" },
    { name = "amount", type = "FLOAT", mode = "NULLABLE" },
    { name = "timestamp", type = "TIMESTAMP", mode = "NULLABLE" }
  ])
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_vertex_ai_featurestore" "fraud_feature_store" {
  name     = "fraud-feature-store"
  project  = google_project.fraud_detection.project_id
  location = "europe-west2"
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_vertex_ai_featurestore_entitytype" "transactions" {
  name          = "transactions"
  featurestore  = google_vertex_ai_featurestore.fraud_feature_store.name
  project       = google_project.fraud_detection.project_id
  location      = "europe-west2"
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_vertex_ai_featurestore_entitytype" "users" {
  name          = "users"
  featurestore  = google_vertex_ai_featurestore.fraud_feature_store.name
  project       = google_project.fraud_detection.project_id
  location      = "europe-west2"
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_cloud_run_service" "feature_processor" {
  name     = "feature-processor"
  location = "europe-west2"
  template {
    spec {
      containers {
        image = "gcr.io/${google_project.fraud_detection.project_id}/feature-processor:latest"
        ports {
          container_port = 8080
        }
      }
    }
  }
  labels = {
    team        = "fraud"
    environment = "dev"
  }
}

resource "google_service_account" "bigquery_access" {
  account_id   = "bigquery-access"
  display_name = "BigQuery Access Service Account"
  project      = google_project.fraud_detection.project_id
}

resource "google_service_account" "vertex_ai_agent" {
  account_id   = "vertex-ai-agent"
  display_name = "Vertex AI Agent Service Account"
  project      = google_project.fraud_detection.project_id
}

resource "google_service_account" "cloud_run_service" {
  account_id   = "cloud-run-service"
  display_name = "Cloud Run Service Account"
  project      = google_project.fraud_detection.project_id
}

output "bigquery_dataset_id" {
  value = google_bigquery_dataset.fraud_features.dataset_id
}

output "raw_data_bucket_name" {
  value = google_storage_bucket.raw_data.name
}

output "processed_data_bucket_name" {
  value = google_storage_bucket.processed_data.name
}
