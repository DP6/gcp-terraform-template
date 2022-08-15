
variable "project" {}
variable "provider_region" {}
variable "artifact_bucket" {}

provider "google" {
  project = var.project
  region  = var.provider_region
}

resource "google_storage_bucket" "function_bucket" {

  project                     = var.project
  name                        = var.artifact_bucket
  location                    = var.provider_region
  uniform_bucket_level_access = true
  force_destroy               = true
  versioning {
    enabled = true
  }
}
