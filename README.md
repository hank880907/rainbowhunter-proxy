# Rainbow Hunter Proxy

A Minecraft proxy server built with Velocity, running in Docker for easy deployment and management.

## Overview

This project provides a containerized Minecraft proxy server using Velocity. It handles player connections, server forwarding, and protocol management with support for multiple Minecraft versions via ViaVersion.

## Prerequisites

- Docker or Podman
- Make (for running build commands)
- `forwarding.secret` file in the project root (for server forwarding authentication)

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