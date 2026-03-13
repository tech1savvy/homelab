output "public_ip" {
  value = module.ec2.public_ip
}

output "ipv6_addresses" {
  value = module.ec2.ipv6_addresses
}

output "instance_id" {
  value = module.ec2.instance_id
}
