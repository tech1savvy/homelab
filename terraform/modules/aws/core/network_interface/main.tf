resource "aws_network_interface" "main" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids

  ipv6_address_count = 1

  tags = {
    Name = var.interface_name
  }
}
