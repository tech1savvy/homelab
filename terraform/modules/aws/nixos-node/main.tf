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

module "key" {
  source     = "../core/key_pair"
  key_name   = "${var.node_name}-key"
  public_key = var.public_key
}

module "ec2" {
  source               = "../core/compute"
  ami_id               = data.aws_ami.nixos.id
  instance_type        = var.instance_type
  instance_state       = var.instance_state
  network_interface_id = var.network_interface_id
  key_name             = module.key.key_name
  instance_name        = var.node_name
  root_volume_size     = var.root_volume_size
}
