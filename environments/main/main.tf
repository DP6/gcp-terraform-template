
variable "project" {}

variable "provider_region" {}

variable "artifact_bucket" {}

provider "google" {
  project = var.project
  region  = var.provider_region
}

module "cloudfunction" {
  project = var.project
  source  = "../../src/functions"

  artifact_bucket = var.artifact_bucket
}
