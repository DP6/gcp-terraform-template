
variable "project" {}
variable "artifact_bucket" {}
variable "location" {}

variable "function_name" {}
variable "description" {}
variable "runtime" {}
variable "entry_point" {}
variable "timeout" {}
variable "available_memory" {}
variable "max_instances" {}
variable "max_instance_request_concurrency" {}

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

resource "google_cloudfunctions2_function" "default" {
  name        = var.function_name
  location    = var.location
  project     = var.project
  description = var.description

  build_config {
    runtime               = var.runtime
    entry_point           = var.entry_point
    environment_variables = var.environment_variables
    source {
      storage_source {
        bucket = var.artifact_bucket
        object = module.google_storage_bucket_object.name
      }
    }
  }

  service_config {
    max_instance_count               = var.max_instances
    max_instance_request_concurrency = var.max_instance_request_concurrency
    available_memory                 = var.available_memory
    timeout_seconds                  = var.timeout
  }
}

output "function_uri" {
  value = google_cloudfunctions2_function.default.service_config[0].uri
}


