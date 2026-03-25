# NixOS Homelab on AWS

A declarative, remotely managed NixOS homelab server deployed on AWS, featuring K3s Kubernetes cluster with automated SSL certificates (Cert-Manager), Rancher, and monitoring stack.

## Project Overview

This project uses **Terraform** for infrastructure provisioning and **Nix Flakes** with `deploy-rs` for declarative system configuration. It aims to provide a reproducible and scalable homelab environment with full infrastructure-as-code (IaC) practices and CI/CD automation.

### Tech Stack

| Category | Technologies |
|----------|--------------|
| Operating System | NixOS (Amazon Linux-based AWS EC2) |
| Cloud Provider | AWS (VPC, EC2, S3 for state, DynamoDB for locking) |
| Container Orchestration | K3s (Lightweight Kubernetes) |
| Infrastructure as Code | Terraform |
| Configuration Management | Nix Flakes + NixOS |
| Deployment Tool | [deploy-rs](https://github.com/serokell/deploy-rs) |
| Secrets Management | SOPS-Nix (Age encryption) |
| CI/CD | GitHub Actions |
| DNS | Cloudflare |

### Domain

- **Main:** lab.tech1savvy.me
- **Rancher:** rancher.tech1savvy.me
- **Grafana:** grafana.tech1savvy.me
- **Prometheus:** prometheus.tech1savvy.me
- **Alertmanager:** alertmanager.tech1savvy.me

## Directory Structure

```bash
├── .github/workflows/          # CI/CD pipelines
│   ├── deploy.yml             # Main NixOS deployment workflow
│   ├── apply.yml              # Terraform apply workflow
│   ├── plan.yml               # Terraform plan workflow
│   └── validate.yml           # Validation workflow
├── .sops.yaml                 # SOPS age key configuration
├── configuration.nix          # Base NixOS system configuration
├── flake.nix                  # Nix Flake entry point
├── hosts/
│   └── aws.nix                # AWS-specific NixOS imports
├── modules/
│   ├── k3s/                   # K3s cluster configuration
│   │   ├── default.nix        # Main K3s module
│   │   ├── server.nix         # K3s server role
│   │   ├── agent.nix          # K3s agent role (optional)
│   │   ├── charts.nix         # Helm chart deployments
│   │   ├── networking.nix     # Firewall rules
│   │   ├── secrets.nix        # Secret management
│   │   ├── manifests/         # K8s manifests (key-sensei app)
│   │   └── helm/              # Helm values files
│   └── sops.nix               # SOPS configuration
├── secrets/
│   └── secrets.yaml           # Encrypted secrets file
├── terraform/                 # AWS infrastructure
│   ├── main.tf                # Main Terraform configuration
│   ├── provider.tf            # Provider configuration
│   ├── outputs.tf             # Output definitions
│   ├── variables.tf           # Variable definitions
│   ├── modules/               # Reusable Terraform modules
│   │   ├── aws/core/          # Core AWS modules (network, security groups, key pair, compute)
│   │   ├── aws/nixos-node/    # EC2 instance module
│   │   └── cloudflare/dns/    # DNS module
│   └── README.md              # Terraform documentation
├── Vagrantfile               # Local development with Vagrant
├── DEPLOY.md                 # Deployment & CD guide
├── WORTH.md                  # Resume advice for this project
└── README.md                 # This file
```

## Prerequisites

- [Nix](https://nixos.org/download.html) with Flakes enabled.
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0).
- AWS CLI configured with appropriate credentials.
- [Age](https://github.com/FiloSottile/age) for secrets encryption.
- [SOPS](https://github.com/mozilla/sops) for secrets management.
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

### 4. Deploy NixOS Configuration

From the project root, deploy the configuration to the AWS instance:

```bash
deploy .#homelab
```

## Features

### K3s Cluster

The system automatically sets up a K3s server on an ARM64 (t4g.medium EC2) instance. Firewall rules are pre-configured in `modules/k3s/networking.nix` for both API server access (port 6443) and Flannel networking (port 8472 UDP).

### Managed Helm Charts

Using NixOS's declarative K3s module, the following charts are automatically deployed:

- **kube-prometheus-stack** (enabled): Full monitoring stack including:
  - Prometheus (90s scrape interval, 12h retention, 3GiB storage)
  - Alertmanager (with ingress)
  - Grafana (with ingress)
  - Custom alerts for High CPU and High Memory usage
- **Cert-Manager** (disabled): For automated SSL certificate management.
- **Rancher** (disabled): Container management UI.

### Key-Sensei Application

The project includes a sample application deployment in `modules/k3s/manifests/` consisting of:
- MongoDB database
- Server component
- Client component

### Secrets Management

Secrets are managed using **SOPS-Nix** with **Age** encryption. The `.sops.yaml` file configures age key paths for different environments. Encrypted secrets are stored in `secrets/secrets.yaml` and decrypted automatically during deployment.

### CI/CD Automation

GitHub Actions workflows in `.github/workflows/` automate the deployment process:

- **deploy.yml**: Main NixOS deployment via deploy-rs (triggered on push to main)
- **apply.yml**: Terraform apply workflow
- **plan.yml**: Terraform plan workflow
- **validate.yml**: Validation workflow

Terraform state is stored in S3 with DynamoDB locking for safe concurrent operations.

## Customization

- **AWS Region:** Modify `terraform/variables.tf`.
- **Instance Type:** Update the instance type in `terraform/modules/aws/nixos-node/`.
- **SSH Keys:** Update the `root` user's authorized keys in `configuration.nix`.
- **K3s Workloads:** Add manifests to `modules/k3s/manifests/` or new Helm charts to `modules/k3s/charts.nix`.
- **Add/Remove Helm Charts:** Modify `modules/k3s/charts.nix` to enable/disable or add new charts.
