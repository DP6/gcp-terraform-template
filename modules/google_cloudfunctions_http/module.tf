
variable "project" {}
variable "artifact_bucket" {}

variable "function_name" {}
variable "description" {}
variable "runtime" {}
variable "entry_point" {}
variable "timeout" {}
variable "available_memory_mb" {}

variable "environment_variables" {}

variable "is_typescript" {}

module "zip_file" {
  source = "../zip_file"

  function_name = var.function_name
  root_dir      = abspath("../../")
  is_typescript = var.is_typescript
}

module "google_storage_bucket_object" {
  source = "../google_storage_bucket_object"

  function_name   = var.function_name
  artifact_bucket = var.artifact_bucket
  zip_source      = module.zip_file.zip_path
}

resource "google_cloudfunctions_function" "function" {
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#argument-reference

  name                = var.function_name
  description         = var.description
  runtime             = var.runtime
  entry_point         = var.entry_point
  timeout             = var.timeout
  available_memory_mb = var.available_memory_mb

  source_archive_bucket = var.artifact_bucket
  source_archive_object = module.google_storage_bucket_object.name

  environment_variables = var.environment_variables

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#event_type
  trigger_http = true
}

resource "google_cloudfunctions_function_iam_member" "member" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
