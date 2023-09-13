# Configure the DNS Provider
provider "dns" {
  update {
    server = "127.0.0.1"
  }
}

module "dns_updater" {
  
  source = "../../."
  input-json-dir = var.input-json-dir
}

output "jsonpath" {
  value = module.dns_updater.input_path
}

output "jsonfiles" {
  value = module.dns_updater.entry_files
}