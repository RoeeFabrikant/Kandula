# VPC OUTPUT

output "vpc_id" {
    value = aws_vpc.vpc.id
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

output "consul_server_sg" {
    value = aws_security_group.consul_server_sg.id
}

output "jenkins_server_sg" {
    value = aws_security_group.jenkins_server_sg.id
}

output "kandula_sg" {
    value = aws_security_group.kandula_sg.id
}

output "all_worker_mgmt" {
    value = aws_security_group.all_worker_mgmt.id
}

output "consul_iam_profile" {
    value = aws_iam_instance_profile.consul-iam.name
}

output "admin_iam_profile_name" {
    value = aws_iam_instance_profile.admin_profile.name
}

output "admin_iam_profile_arn" {
    value = aws_iam_instance_profile.admin_profile.arn
}

output "aws_route53_zone_id" {
    value = aws_route53_zone.kandula_route53_zone.zone_id
}

# output "alb_sg" {
#     value = aws_security_group.alb_sg.id
# }

# output "ssh_sg" {
#     value = aws_security_group.ssh_sg.id
# }