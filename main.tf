/**
*
* # Terraform Coding Exercise
*
* Please read the [instructions](./INSTRUCTIONS.md) file.
*
* # Steps
*
* 
*
* # Terraform Module dns_updater
*
* This terraform module is intended to configure in the DNS server with the entries in a dynamic way.
* 
*  ## Usage
*  
*  - In the root terraform manifest, it is necessary to call this module
*  - It is also necessary to provide the name, en relative path to the directory containing the JSON files with the DNS entries
*  - In case this JSON directory is not provided, the module will use the default entry value.
*  - After run terraform command in the dorectory root, with the options init, plan and apply, the DNS entries into the JSON directory will be configured in the DNS server.
*
*
*  ## DISCLAIMER
*
*  This module is still a test, so it lacks of security measures to configure the DNS Server in a dynamic way, and also, it lacks of automation to be deployed.
*
*  ## Locals variables
*
* - The json_files variable, set the relative path to the JSON Directory, and get all files with json extension inside it.
* - The json_variable, evaluate if the JSON Directory has files or it is a wrong path, in that case, it configure the default entry. In case, the JSON files exists, each one are going to be parsed and mapped in json format to be processed.
*
* ## dns_a_record_set resource
*
* - The resource is using the public provider hashicorp/dns.
* - Only can be used to create entries type A into the DNS Server
* - This resource iterate in all values provided by the DNS JSON files and perform the configuration in the DNS Server configured
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

