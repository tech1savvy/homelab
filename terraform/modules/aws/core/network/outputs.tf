output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.main.ipv6_cidr_block
}
