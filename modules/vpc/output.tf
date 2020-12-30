# VPC OUTPUT

output "vpc" {
    value = aws_vpc.vpc.*.id
}

output "igw" {
    value = aws_internet_gateway.igw.id
}

output "private_sub" {
    value = aws_subnet.private_sub.*.id
}

output "public_sub" {
    value = aws_subnet.public_sub.*.id
}

output "eip" {
    value = aws_eip.eip.*.id
}

output "rt_privatesub" {
    value = aws_route_table.rt_privatesub.*.id
}

output "rt_publicsub" {
    value = aws_route_table.rt_publicsub.*.id
}

output "sg" {
    value = aws_security_group.sg.id
}

#output "consul_iam_profile" {
#    value = aws_iam_role.consul-join.name
#}