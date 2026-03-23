
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
    # K3s API
    {
      from_port        = 6443
      to_port          = 6443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
  ]
}

module "nixos_node" {
  source                 = "./modules/aws/nixos-node"
  instance_type          = "t4g.medium"
  vpc_id                 = module.network.vpc_id
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [module.node_sg.security_group_id]
  node_name              = "nixos-native-node"
  instance_state         = local.identifiers.node_state
  public_key             = local.public_key
  architecture           = "arm64"
  root_volume_size       = 30
}

module "dns" {
  source             = "./modules/cloudflare/dns"
  cloudflare_zone_id = local.identifiers.cloudflare_zone_id
  lab                = module.nixos_node.public_ip
}
