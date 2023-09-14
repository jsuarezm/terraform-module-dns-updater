/**
*
* # Terraform Coding Exercise
*
* Please read the [instructions](./INSTRUCTIONS.md) file.
*
* # Steps
*
* - [x] Clone a local repository
* - [x] Analyze the current functionality and code, test it
*	- [x] Run test environment
* - [x] Analyze the requirement, questions, what is it the interpretation about them? Make assumptions
* - [x] Build script to parser the json files and output the DNS registry statement
* - [x] Implement the dynamic configuration for A type entries
* - [x] Document the README.md using terraform docs
* - [x] Implement the dynamic configuration for CNAME type entries and update the documentation
* - [x] Add Improvements
* - [x] publish in Github
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
* - The json_a_data and json_cname_data variables, both evaluate if the JSON Directory has files or it is a wrong path, in that case, it configure the default entry. In case, the JSON files exists, each one are going to be parsed and mapped in json format to be processed. 
*
* ## dns_a_record_set resource
*
* - The resource is using the public provider hashicorp/dns.
* - Only can be used to create entries type A into the DNS Server
* - This resource iterate in all values provided by the DNS JSON files and perform the configuration in the DNS Server configured
*
*/
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

  json_a_data = length(local.json_files) > 0 ? toset([for f in local.json_files : merge(jsondecode(file("${path.root}/${f}")),{name=trimsuffix(basename("${f}"),".json")}) if lookup(jsondecode(file("${path.root}/${f}")),"dns_record_type", "NO") == "a"]) : toset([var.default_a_entry])

    json_cname_data = length(local.json_files) > 0 ? toset([for f in local.json_files : merge(jsondecode(file("${path.root}/${f}")),{name=trimsuffix(basename("${f}"),".json")}) if lookup(jsondecode(file("${path.root}/${f}")),"dns_record_type", "NO") == "cname"]) : toset([var.default_cname_entry])
}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "entries" {
  for_each   = {
    for index, entry in local.json_a_data:
    entry.name => entry
    if entry.dns_record_type == "a"
  } 
  zone = each.value.zone
  name = each.value.name
  addresses = each.value.addresses
  ttl = tonumber(each.value.ttl)
}

resource "dns_cname_record" "cname_entries" {
  for_each   = {
    for index, entry in local.json_cname_data:
    entry.name => entry
    if entry.dns_record_type == "cname"
  } 
  zone = each.value.zone
  name = each.value.name
  cname = each.value.cname
  ttl = tonumber(each.value.ttl)
}
