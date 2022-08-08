
variable "project" {}
variable "artifact_bucket" {}

locals {
  timestamp     = formatdate("YYMMDDhhmmss", timestamp())
  root_dir      = abspath("../../")
  function_name = basename(path.module)

  # google_cloudfunctions_function config
  description         = "Typescript function template"
  runtime             = "nodejs16" # https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes
  entry_point         = "main"     # CF function entry name
  timeout             = 540
  available_memory_mb = "128"
}

resource "null_resource" "typescript" {
  provisioner "local-exec" {
    working_dir = path.module
    command     = "npm install typescript --save-dev"
  }
  provisioner "local-exec" {
    working_dir = path.module
    command     = "npm run build"
  }
  provisioner "local-exec" {
    working_dir = path.module
    command     = "npm run move"
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${local.root_dir}/src/functions/${local.function_name}/dist"
  output_path = "${local.root_dir}/assets/function-${local.function_name}.zip"
}

resource "google_storage_bucket_object" "source" {
  name   = "functions-${local.function_name}-source.zip"
  bucket = var.artifact_bucket
  source = data.archive_file.zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#argument-reference

  name        = local.function_name
  description = local.description
  runtime     = local.runtime
  timeout     = local.timeout

  available_memory_mb   = local.available_memory_mb
  source_archive_bucket = var.artifact_bucket
  source_archive_object = google_storage_bucket_object.source.name
  entry_point           = local.entry_point

  environment_variables = {
  }

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
