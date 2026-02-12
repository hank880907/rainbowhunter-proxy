# Rainbow Hunter Proxy

A Minecraft proxy server built with Velocity, running in Docker for easy deployment and management.

## Overview

This project provides a containerized Minecraft proxy server using Velocity. It handles player connections, server forwarding, and protocol management with support for multiple Minecraft versions via ViaVersion.

## Prerequisites

- Docker or Podman
- Make (for running build commands)
- `forwarding.secret` file in the project root (for server forwarding authentication)

## Gcloud permissions

User need to enable these gcloud permissions.

```bash
gcloud services enable compute.googleapis.com --project=rainbowhunter-proxy
gcloud services enable secretmanager.googleapis.com --project=rainbowhunter-proxy
```

# Deployment

Example: deploy extra plugins to australia GCP instance

```bash
terraform apply -var="region=australia-southeast1" -var="machine_type=e2-standard-4" -var="proxy_tag=latest-additional"
```

## Taiwan 

```bash
terraform apply -var="region=asia-east1" -var="machine_type=e2-standard-4" -var="proxy_tag=latest-additional"

# budget version
terraform apply -var="region=asia-east1" -var="machine_type=e2-micro" -var="proxy_tag=latest"
```

## Quick Start

### Build the Image

```bash
make velocity
```

### Run the Container

```bash
make run
```

This will:
- Build and run the Velocity proxy server
- Expose the proxy on port 25565
- Mount `forwarding.secret` for server authentication