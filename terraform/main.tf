
locals {
  public_key = file(pathexpand(local.identifiers.public_key_path))
}

module "network" {
  source   = "./modules/aws/core/network"
  vpc_name = "lab-vpc"
}

module "node_sg" {
  source  = "./modules/aws/core/security_group"
  vpc_id  = module.network.vpc_id
  sg_name = "nixos-native-node-sg"

  ingress_rules = [
    # SSH
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    # HTTP
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    # HTTPS
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
  ]
}

module "static_identity" {
  source             = "./modules/aws/core/network_interface"
  subnet_id          = module.network.public_subnet_id
  security_group_ids = [module.node_sg.security_group_id]
  interface_name     = "nixos-stable-ip"
}

module "nixos_node" {
  source               = "./modules/aws/nixos-node"
  vpc_id               = module.network.vpc_id
  network_interface_id = module.static_identity.id
  node_name            = "nixos-native-node"
  instance_state       = local.identifiers.node_state
  public_key           = local.public_key
}

module "dns" {
  source             = "./modules/cloudflare/dns"
  cloudflare_zone_id = local.identifiers.cloudflare_zone_id
  lab                = module.nixos_node.public_ip
}
