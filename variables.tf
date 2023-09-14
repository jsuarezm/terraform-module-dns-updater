# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------


variable "input-json-dir" {
  description = "Input of directory name containing the JSON files with the DNS entries"
}

variable "default_a_entry" {
  description = "Default DNS entry, in case there are not JSON files with entries, or wrong directory name"
  type = object({
    name       = string
    zone       = string
    addresses  = list(string)
    ttl        = number
    dns_record_type = string
  })
  default = {
    name = "www"
    zone = "example.com."
    addresses = [
      "192.168.0.1",
     "192.168.0.2",
     "192.168.0.3",
    ]
    ttl = 300
    dns_record_type = "a"
  }
} 

variable "default_cname_entry" {
  description = "Default DNS entry, in case there are not JSON files with entries, or wrong directory name"
  type = object({
    name       = string
    zone       = string
    cname      = string
    ttl        = number
    dns_record_type = string
  })
  default = {
    name = "cname"
    zone = "example.com."
    cname = "xxx.example.com."
    ttl = 300
    dns_record_type = "cname"
  }
} 