
variable "project" {}
variable "artifact_bucket" {}

resource "random_uuid" "bucket_suffix" {}

module "terraform_template_function" {

  source = "./terraform_template"

  project         = var.project
  artifact_bucket = var.artifact_bucket
}
