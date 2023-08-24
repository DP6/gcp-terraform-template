
variable "project" {}
variable "provider_region" {}
variable "artifact_bucket" {}

provider "google" {
  project = var.project
  region  = var.provider_region
}

module "cloudfunction" {
  source = "../../src/functions"

  project         = var.project
  artifact_bucket = var.artifact_bucket
  location        = var.provider_region
}
