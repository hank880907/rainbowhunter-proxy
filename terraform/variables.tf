variable "project_id" { 
    type = string 
}

variable "netbird_setup_key" { 
    type = string
    sensitive = true
}

variable "forwarding_secret" {
    type      = string
    sensitive = true
    description = "Velocity forwarding secret for server authentication"
}

# variable "velocity_image" { 
#     type = string 
# }

variable "region" {
  type    = string
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
  description = "GCP machine type for the proxy instance"
}

variable "proxy_tag" {
  type    = string
  default = "latest"
  description = "tag for the Velocity proxy"
}