terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.3.0"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}
