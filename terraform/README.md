# Homelab Terraform Infrastructure

This repository contains the Terraform configuration for managing homelab infrastructure on AWS. It uses a modular approach to deploy and manage resources, specifically focusing on NixOS-based EC2 instances.

## Project Structure

The project is organized into several modules to ensure reusability and maintainability:

```text
.
├── main.tf              # Main entry point for the infrastructure
├── provider.tf          # Terraform provider and backend configuration
├── variables.tf         # Global variables
├── outputs.tf           # Global outputs
└── modules/
    ├── core/            # Fundamental infrastructure components
    │   ├── network/     # VPC, Subnet, Internet Gateway, and Routing
    │   ├── compute/     # EC2 instance management
    │   ├── key_pair/    # AWS SSH Key Pair management
    │   └── security_group/ # Security Group rules
    └── nixos-node/      # Orchestrator module for NixOS instances
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.5.7)
- AWS CLI configured with appropriate credentials.
- An SSH key pair (defaults to `~/.ssh/id_ed25519.pub`).

## Modules Overview

### Core Modules

- **Network**: Sets up a VPC with a public subnet, internet gateway, and route tables.
- **Compute**: Manages AWS EC2 instances, including root volume size and instance type.
- **Key Pair**: Handles the creation of AWS key pairs for SSH access.
- **Security Group**: Configures firewall rules for instances.

### NixOS Node Module

The `nixos-node` module is a high-level orchestrator that:
1.  Fetches the latest official NixOS AMI for the specified architecture.
2.  Creates a security group with SSH and HTTP access.
3.  Registers the SSH public key.
4.  Deploys an EC2 instance using the NixOS AMI.

## Usage

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

2.  **Customize Variables**:
    Create a `terraform.tfvars` file or override defaults in `variables.tf`:
    ```hcl
    region          = "ap-south-1"
    public_key_path = "~/.ssh/id_ed25519.pub"
    node_state      = "running"
    ```

3.  **Plan and Apply**:
    ```bash
    terraform plan
    terraform apply
    ```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `region` | AWS region to deploy to | `string` | `"ap-south-1"` |
| `public_key_path` | Path to your SSH public key | `string` | `"~/.ssh/id_ed25519.pub"` |
| `node_state` | Desired state of the node (`running` or `stopped`) | `string` | `"running"` |

## Outputs

The project provides outputs such as the instance public IP for easier access.

| Name | Description |
|------|-------------|
| `public_ip` | The public IP of the deployed NixOS node. |

Run `terraform output` after deployment to see the values.
