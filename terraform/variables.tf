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

variable "region" {
  type    = string
  default = "asia-east1"
}

variable "machine_type" {
  type    = string
  default = "e2-small"
  description = "GCP machine type for the proxy instance"
}

variable "proxy_tag" {
  type    = string
  default = "latest-additional"
  description = "tag for the Velocity proxy"
}