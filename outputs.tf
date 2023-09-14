# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------

output "input_path" {
  description = "Name of the JSON directory provided as input"
  value = var.input-json-dir
}

output "entry_files" {
  description = "List of JSON files with parsed containing the DNS entries"
  value = local.json_files
}

output "entries_processed" {
  description = "JSON of all entries processed"
  value = local.json_data
}

output "dentry" {
  description = "Value of the default entry. Used for debugging"
  value = toset([var.default_a_entry])
}
