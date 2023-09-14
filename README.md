
# Terraform Coding Exercise

Please read the [instructions](./INSTRUCTIONS.md) file.

# Steps

- [x] Clone a local repository
- [x] Analyze the current functionality and code, test it
*	- [x] Run test environment
- [x] Analyze the requirement, questions, what is it the interpretation about them? Make assumptions
- [x] Build script to parser the json files and output the DNS registry statement
- [x] Implement the dynamic configuration for A type entries
- [x] Document the README.md using terraform docs
- [x] Implement the dynamic configuration for CNAME type entries and update the documentation
- [x] Add Improvements
- [x] publish in Github

# Terraform Module dns\_updater

This terraform module is intended to configure in the DNS server with the entries in a dynamic way.

 ## Usage

 - In the root terraform manifest, it is necessary to call this module
 - It is also necessary to provide the name, en relative path to the directory containing the JSON files with the DNS entries
 - In case this JSON directory is not provided, the module will use the default entry value.
 - After run terraform command in the dorectory root, with the options init, plan and apply, the DNS entries into the JSON directory will be configured in the DNS server.

 ## DISCLAIMER

 This module is still a test, so it lacks of security measures to configure the DNS Server in a dynamic way, and also, it lacks of automation to be deployed.

 ## Locals variables

- The json\_files variable, set the relative path to the JSON Directory, and get all files with json extension inside it.
- The json\_a\_data and json\_cname\_data variables, both evaluate if the JSON Directory has files or it is a wrong path, in that case, it configure the default entry. In case, the JSON files exists, each one are going to be parsed and mapped in json format to be processed.

## dns\_a\_record\_set resource

- The resource is using the public provider hashicorp/dns.
- Only can be used to create entries type A into the DNS Server
- This resource iterate in all values provided by the DNS JSON files and perform the configuration in the DNS Server configured

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_dns"></a> [dns](#requirement\_dns) | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_dns"></a> [dns](#provider\_dns) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [dns_a_record_set.entries](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/a_record_set) | resource |
| [dns_cname_record.cname_entries](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/cname_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_a_entry"></a> [default\_a\_entry](#input\_default\_a\_entry) | Default DNS entry, in case there are not JSON files with entries, or wrong directory name | <pre>object({<br>    name       = string<br>    zone       = string<br>    addresses  = list(string)<br>    ttl        = number<br>    dns_record_type = string<br>  })</pre> | <pre>{<br>  "addresses": [<br>    "192.168.0.1",<br>    "192.168.0.2",<br>    "192.168.0.3"<br>  ],<br>  "dns_record_type": "a",<br>  "name": "www",<br>  "ttl": 300,<br>  "zone": "example.com."<br>}</pre> | no |
| <a name="input_default_cname_entry"></a> [default\_cname\_entry](#input\_default\_cname\_entry) | Default DNS entry, in case there are not JSON files with entries, or wrong directory name | <pre>object({<br>    name       = string<br>    zone       = string<br>    cname      = string<br>    ttl        = number<br>    dns_record_type = string<br>  })</pre> | <pre>{<br>  "cname": "xxx.example.com.",<br>  "dns_record_type": "cname",<br>  "name": "cname",<br>  "ttl": 300,<br>  "zone": "example.com."<br>}</pre> | no |
| <a name="input_input-json-dir"></a> [input-json-dir](#input\_input-json-dir) | Input of directory name containing the JSON files with the DNS entries | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dentry"></a> [dentry](#output\_dentry) | Value of the default entry. Used for debugging |
| <a name="output_entries_processed"></a> [entries\_processed](#output\_entries\_processed) | JSON of all entries processed |
| <a name="output_entry_files"></a> [entry\_files](#output\_entry\_files) | List of JSON files with parsed containing the DNS entries |
| <a name="output_input_path"></a> [input\_path](#output\_input\_path) | Name of the JSON directory provided as input |
