# ------------------------------------------
# Write your Terraform variable inputs here
# ------------------------------------------

variable "input-json-dir" {
  description = "path of the directory with JSON files with the DNS entries"
}

variable "default_a_entry" {
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