terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# --- DATA SOURCES FOR VALIDATION ---

data "google_compute_regions" "available" {}

data "google_compute_zones" "available" {
  region = var.region
}

# --- NETWORKING ---

resource "google_compute_address" "static_ip" {
  name   = "velocity-proxy-ip-${var.region}"
  region = var.region
  network_tier = "PREMIUM"
}

resource "google_compute_firewall" "proxy_firewall" {
  name    = "velocity-p2p-firewall-${var.region}"
  network = "default"

  # Minecraft Traffic
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  # Netbird P2P Handshake (Direct WireGuard)
  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-proxy"]
}

# --- THE VIRTUAL MACHINE ---

resource "google_compute_instance" "proxy" {
  name         = "velocity-proxy-${var.region}"
  machine_type = "e2-micro"
  zone = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
      network_tier = "PREMIUM"
    }
  }

  tags = ["minecraft-proxy"]

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      netbird_setup_key = var.netbird_setup_key
    #   velocity_image    = var.velocity_image

    })
  }

  # --- DYNAMIC VALIDATION BLOCK ---
  lifecycle {
    precondition {
      condition     = contains(data.google_compute_regions.available.names, var.region)
      error_message = "Region '${var.region}' is not valid for this project. Check 'gcloud compute regions list'."
    }
  }
}

output "proxy_public_ip" {
  value = google_compute_address.static_ip.address
}