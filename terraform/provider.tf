ephemeral "sops_file" "secrets" {
  source_file = "secrets.terraform.json"
}
data "sops_file" "identifiers" {
  source_file = "identifiers.terraform.json"
}

locals {
  secrets     = jsondecode(ephemeral.sops_file.secrets.raw)
  identifiers = jsondecode(data.sops_file.identifiers.raw)
}

provider "aws" {
  region = local.identifiers.region
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare_api_token
}


terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.4.0"
    }
  }

  backend "s3" {
    bucket       = "tech1savvy-tf-state"
    key          = "lab/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}


