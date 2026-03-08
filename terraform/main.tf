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

# --- SECRET MANAGEMENT ---

resource "google_secret_manager_secret" "forwarding_secret" {
  secret_id = "velocity-forwarding-secret"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "forwarding_secret_version" {
  secret      = google_secret_manager_secret.forwarding_secret.id
  secret_data = var.forwarding_secret
}

# Service account for the VM
resource "google_service_account" "proxy_sa" {
  account_id   = "rainbowhunter-proxy-sa"
  display_name = "Rainbowhunter Proxy Service Account"
}

# Grant secret access to the service account
resource "google_secret_manager_secret_iam_member" "proxy_secret_access" {
  secret_id = google_secret_manager_secret.forwarding_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.proxy_sa.email}"
}

# --- NETWORKING ---

resource "google_compute_address" "static_ip" {
  name   = "rainbowhunter-${var.region}"
  region = var.region
  network_tier = "PREMIUM"
}

resource "google_compute_firewall" "proxy_firewall" {
  name    = "velocity-p2p-firewall"
  network = "default"

  # Minecraft Traffic
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  # GeyserMC (Bedrock Edition)
  allow {
    protocol = "udp"
    ports    = ["19132"]
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

# resource "google_compute_instance" "proxy" {
#   name         = "velocity-proxy-${var.region}"
#   machine_type = var.machine_type
#   zone = data.google_compute_zones.available.names[0]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#     }
#   }

#   network_interface {
#     network = "default"
#     access_config {
#       nat_ip = google_compute_address.static_ip.address
#       network_tier = "PREMIUM"
#     }
#   }

#   service_account {
#     email  = google_service_account.proxy_sa.email
#     scopes = ["cloud-platform"]
#   }

#   tags = ["minecraft-proxy"]

#   scheduling {
#     automatic_restart   = true
#     on_host_maintenance = "MIGRATE"
#     preemptible         = false
#     provisioning_model  = "STANDARD"
#   }

#   metadata = {
#     user-data = templatefile("${path.module}/cloud-init.yaml", {
#       netbird_setup_key = var.netbird_setup_key
#       project_id        = var.project_id
#       secret_id         = google_secret_manager_secret.forwarding_secret.secret_id
#       proxy_tag      = var.proxy_tag
#     })
#   }
# }

resource "google_compute_instance" "proxy-micro" {
  name         = "velocity-proxy-micro"
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

  service_account {
    email  = google_service_account.proxy_sa.email
    scopes = ["cloud-platform"]
  }

  tags = ["minecraft-proxy"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  metadata = {
    user-data = templatefile("${path.module}/micro/cloud-init.yaml", {
      netbird_setup_key = var.netbird_setup_key
      project_id        = var.project_id
      secret_id         = google_secret_manager_secret.forwarding_secret.secret_id
      proxy_tag      = "latest"
    })
  }
}

output "proxy_public_ip" {
  value = google_compute_address.static_ip.address
}