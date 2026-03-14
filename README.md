# NixOS Homelab on AWS

A declarative, remotely managed NixOS homelab server deployed on AWS, featuring K3s with Cert-Manager and Rancher.

## Project Overview

This project uses **Terraform** for infrastructure provisioning and **Nix Flakes** with `deploy-rs` for declarative system configuration. It aims to provide a reproducible and scalable homelab environment.

### Tech Stack
- **OS:** NixOS (Amazon Image)
- **Cloud:** AWS (VPC, EC2)
- **Container Orchestration:** K3s
- **Infrastructure as Code:** Terraform
- **Deployment:** [deploy-rs](https://github.com/serokell/deploy-rs)
- **Add-ons:** Cert-Manager, Rancher (managed via NixOS `services.k3s.autoDeployCharts`)

## Directory Structure

```bash
├── configuration.nix       # Base NixOS configuration
├── flake.nix               # Flake entry point & deployment targets
├── hosts/                  # Host-specific configurations (e.g., aws.nix)
├── modules/
│   └── k3s/                # K3s configuration, networking, and Helm charts
└── terraform/              # AWS infrastructure (VPC, Security Groups, EC2)
    ├── modules/            # Reusable Terraform modules (network, compute, etc.)
    └── main.tf             # Main infrastructure entry point
```

## Prerequisites

- [Nix](https://nixos.org/download.html) with Flakes enabled.
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0).
- AWS CLI configured with appropriate credentials.
- `deploy-rs` installed (`nix profile install github:serokell/deploy-rs`).

## Getting Started

### 1. Provision Infrastructure
Navigate to the `terraform/` directory and apply the configuration:

```bash
cd terraform
terraform init
terraform apply
```

Note the public IP and IPv6 addresses of the created instance from the outputs.

### 2. Managing Node Lifecycle (Static IP Persistence)
The infrastructure is designed to keep your **IPv6 address stable** even if the server is recreated.

*   **To destroy ONLY the NixOS node (keeping the Static IP):**
    ```bash
    terraform destroy -target=module.nixos_node
    ```
    *Use this if you want to wipe the server but keep its identity for DNS/access.*

*   **To recreate the node (e.g., after changing instance type):**
    ```bash
    terraform apply
    ```
    *The new instance will automatically re-attach to the existing Static IP.*

*   **To destroy EVERYTHING (including the Static IP):**
    ```bash
    terraform destroy
    ```

### 3. Configure Deployment
Update the `hostname` in `flake.nix` under `deploy.nodes.homelab` with the public IP address obtained from Terraform.

```nix
deploy.nodes.homelab = {
  hostname = "YOUR_INSTANCE_IP";
  # ...
};
```

### 3. Deploy NixOS Configuration
From the project root, deploy the configuration to the AWS instance:

```bash
deploy .#homelab
```

## Features

### K3s Cluster
The system automatically sets up a K3s server. Firewall rules are pre-configured in `modules/k3s/networking.nix` for both API server access (port 6443) and Flannel networking.

### Managed Helm Charts
Using NixOS's declarative K3s module, the following charts are automatically deployed:
- **Cert-Manager:** For automated SSL certificate management.
- **Rancher:** A complete software stack for teams adopting containers, accessible via the hostname configured in `modules/k3s/charts.nix`.

## Customization

- **AWS Region:** Modify `terraform/variables.tf`.
- **SSH Keys:** Update the `root` user's authorized keys in `configuration.nix`.
- **K3s Workloads:** Add manifests to `modules/k3s/manifests/` or new Helm charts to `modules/k3s/charts.nix`.
