
variable "project" {}
variable "artifact_bucket" {}

locals {

  pubsub_config_files = fileset(path.module, "*/pubsub_config.json")

  pubsub_functions = { for pubsub_config_file in local.pubsub_config_files :
  basename(dirname(pubsub_config_file)) => jsondecode(file("${path.module}/${pubsub_config_file}")) }


  http_config_files = fileset(path.module, "*/http_config.json")

  http_functions = { for http_config_file in local.http_config_files :
  basename(dirname(http_config_file)) => jsondecode(file("${path.module}/${http_config_file}")) }
}

module "google_cloudfunctions_pubsub" {
  source = "../../modules/google_cloudfunctions_pubsub"

  for_each = local.pubsub_functions

  topic_name      = each.value.topic_name
  project         = var.project
  artifact_bucket = var.artifact_bucket

  function_name       = each.key
  description         = try(each.value.description, "")
  runtime             = try(each.value.runtime, "nodejs16") # https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes
  entry_point         = try(each.value.entry_point, "main")
  timeout             = try(each.value.timeout, 60)
  available_memory_mb = try(each.value.available_memory_mb, 128)

  environment_variables = try(each.value.environment_variables, {})

  is_typescript = try(each.value.is_typescript, false)
}

module "google_cloudfunctions_http" {
  source = "../../modules/google_cloudfunctions_http"

  for_each = local.http_functions

  project         = var.project
  artifact_bucket = var.artifact_bucket

  function_name       = each.key
  description         = try(each.value.description, "")
  runtime             = try(each.value.runtime, "nodejs16") # https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes
  entry_point         = try(each.value.entry_point, "main")
  timeout             = try(each.value.timeout, 60)
  available_memory_mb = try(each.value.available_memory_mb, 128)

  environment_variables = try(each.value.environment_variables, {})

  is_typescript = try(each.value.is_typescript, false)
}
