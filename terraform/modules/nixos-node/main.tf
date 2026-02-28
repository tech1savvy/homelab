data "aws_ami" "nixos" {
  owners      = ["427812963091"] # Official NixOS
  most_recent = true

  filter {
    name   = "name"
    values = ["nixos/25.11*"]
  }
  filter {
    name   = "architecture"
    values = [var.architecture]
  }
}

module "sg" {
  source  = "../core/security_group"
  vpc_id  = var.vpc_id
  sg_name = "${var.node_name}-sg"

  ingress_rules = [
    # SSH
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # HTTP
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # HTTPS
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "key" {
  source     = "../core/key_pair"
  key_name   = "${var.node_name}-key"
  public_key = var.public_key
}

module "ec2" {
  source             = "../core/compute"
  ami_id             = data.aws_ami.nixos.id
  instance_type      = var.instance_type
  instance_state     = var.instance_state
  subnet_id          = var.subnet_id
  security_group_ids = [module.sg.security_group_id]
  key_name           = module.key.key_name
  instance_name      = var.node_name
  root_volume_size   = var.root_volume_size
}
