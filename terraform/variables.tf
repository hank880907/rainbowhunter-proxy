variable "project_id" { 
    type = string 
}

variable "netbird_setup_key" { 
    type = string
    sensitive = true
}

# variable "velocity_image" { 
#     type = string 
# }

variable "region" {
  type    = string
}