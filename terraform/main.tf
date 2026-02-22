locals {
  public_key = file(pathexpand(var.public_key_path))
}

module "network" {
  source   = "./modules/core/network"
  vpc_name = "homelab-vpc"
}

module "nixos_node" {
  source         = "./modules/nixos-node"
  vpc_id         = module.network.vpc_id
  subnet_id      = module.network.public_subnet_id
  node_name      = "nixos-native-node"
  instance_state = var.node_state
  public_key     = local.public_key
}
