
variable "function_name" {}
variable "artifact_bucket" {}
variable "zip_source" {}

resource "google_storage_bucket_object" "source" {
  name   = "functions-${var.function_name}-source.zip"
  bucket = var.artifact_bucket
  source = var.zip_source
}

resource "google_storage_bucket_object" "latest_source" {
  name       = "${google_storage_bucket_object.source.name}-${google_storage_bucket_object.source.crc32c}.zip"
  bucket     = var.artifact_bucket
  source     = var.zip_source
  depends_on = [google_storage_bucket_object.source]
}

output "name" {
  value = google_storage_bucket_object.latest_source.output_name
}
