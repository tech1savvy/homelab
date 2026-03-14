# Deployment & Continuous Delivery (CD) Guide

This project uses an automated CD pipeline powered by **GitHub Actions**, **Terraform (with S3 Remote State)**, and **deploy-rs**.

---

## 1. Prerequisites & Infrastructure Setup

Before the CD pipeline can run, you must manually set up the remote state storage to ensure Terraform can track infrastructure across different environments (local vs. CI runner).

### A. Create S3 Bucket & DynamoDB Table
1. **S3 Bucket:** Create a private S3 bucket (e.g., `homelab-terraform-state`) in your AWS region (`ap-south-1`).
2. **DynamoDB Table:** Create a table named `terraform-state-lock` with a Partition Key named `LockID` (Type: String).

### B. Update Terraform Backend
Add the following block to your `terraform/provider.tf` file (replace `your-unique-bucket-name` with your actual bucket name):

```hcl
terraform {
  backend "s3" {
    bucket         = "your-unique-bucket-name"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

---

## 2. GitHub Secrets Configuration

To allow GitHub Actions to provision infrastructure and deploy NixOS, you must add the following **Repository Secrets** in your GitHub repository settings (**Settings > Secrets and variables > Actions**):

| Secret Name | Description |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | AWS Access Key with EC2/VPC/S3/DynamoDB permissions. |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key for the above access key. |
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token with `Zone:DNS:Edit` permissions. |
| `CLOUDFLARE_ZONE_ID` | The Zone ID for your domain (e.g., `tech1savvy.me`). |
| `SSH_PRIVATE_KEY` | The private SSH key used to access the `root` user on your NixOS node. |
| `SSH_PUBLIC_KEY` | The public SSH key corresponding to the private key above. |

---

## 3. How the CD Pipeline Works

The pipeline is defined in `.github/workflows/deploy.yml` and triggers on every **push to the `main` branch**.

### Pipeline Steps:
1. **Terraform Provisioning:**
   - Initializes the S3 backend.
   - Applies the infrastructure changes.
   - Updates your Cloudflare DNS record (`lab.tech1savvy.me`) with the new server IP.
2. **NixOS Deployment (`deploy-rs`):**
   - Installs Nix and `deploy-rs` on the runner.
   - Builds your Flake configuration.
   - Deploys the new system profile to `lab.tech1savvy.me` via SSH.

---

## 4. Manual Deployment (Optional)

If you need to deploy manually from your local machine, ensure you have the necessary environment variables set:

```bash
# Infrastructure
export TF_VAR_cloudflare_api_token="your-token"
export TF_VAR_cloudflare_zone_id="your-zone-id"

cd terraform
terraform init
terraform apply

# NixOS Configuration
cd ..
deploy .#lab
```

---

## 5. Troubleshooting

- **SSH Failures:** Ensure the `SSH_PRIVATE_KEY` in GitHub match the public key stored in `configuration.nix`.
- **DNS Propagation:** If a new IP is assigned, it may take a minute for Cloudflare to propagate the change before `deploy-rs` can connect.
- **State Lock:** If a workflow run is interrupted, you may need to manually release the Terraform state lock in the DynamoDB table.
