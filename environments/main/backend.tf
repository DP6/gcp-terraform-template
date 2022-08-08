
terraform {
  # Por enquanto é necessário ter criado pelo menos esse bucket manualmente.
  backend "gcs" {
    bucket = "dp6-tfstate"
    prefix = "env/main"
  }
}
