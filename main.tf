/**
* # Terraform
*
* <Short TF module description>
*
*
* ## Usage
*
* ### Quick Example
*
* ```hcl
* module "dns_" {
*   source = ""
*   input1 = <>
*   input2 = <>
* } 
* ```
*
*/
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}

# ------------------------------------------
# Write your local resources here
# ------------------------------------------

locals {

  json_files = fileset(path.root, "${var.input-json-dir}/*.json")

  json_data = length(local.json_files) > 0 ? toset([for f in local.json_files : merge(jsondecode(file("${path.root}/${f}")),{name=trimsuffix(basename("${f}"),".json")})]) : toset([var.default_a_entry])

}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

# resource "dns_a_record_set" "www" {
#   zone = "example.com."
#   name = "www"
#   addresses = [
#     "192.168.0.1",
#     "192.168.0.2",
#     "192.168.0.3",
#   ]
#   ttl = 300
# }

resource "dns_a_record_set" "entries" {
  for_each   = {
    for index, entry in local.json_data:
    entry.name => entry
  } 
  zone = each.value.zone
  name = each.value.name
  addresses = each.value.addresses
  ttl = tonumber(each.value.ttl)
}

output "input_path" {
  value = var.input-json-dir
}


output "entry_files" {
  value = local.json_files
}

output "entries_processed" {
  value = local.json_data
}

output "dentry" {
  value = toset([var.default_a_entry])
}
