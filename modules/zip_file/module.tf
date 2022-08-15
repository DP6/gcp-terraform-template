
variable "function_name" {}
variable "root_dir" {}

variable "is_typescript" {}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${var.root_dir}/src/functions/${var.function_name}${var.is_typescript ? "/dist" : ""}"
  excludes    = ["node_modules", "package-lock.json"]
  output_path = "${var.root_dir}/assets/function-${var.function_name}.zip"
}

output "zip_path" {
  value = data.archive_file.zip.output_path
}
