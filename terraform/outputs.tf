output "public_ip" {
  value = module.nixos_node.public_ip
}

output "ipv6_addresses" {
  value = module.static_identity.ipv6_addresses
}
