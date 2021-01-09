resource "aws_vpc" "vpc" {
    cidr_block                  = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        "Name" = "${var.project_name}_vpc"
        "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id                      = aws_vpc.vpc.id
    tags        = {
        "Name"  = "${var.project_name}_igw"
    }
}

resource "aws_subnet" "private_sub" {
    count                       = length(var.private_subnet_cidr)
    vpc_id                      = aws_vpc.vpc.id
    availability_zone           = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch     = true
    cidr_block                  = var.private_subnet_cidr[count.index]
    tags = {
        "Name" = "${var.project_name}_private_sub_az${count.index}"
        "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"             = "1"
    }
}

resource "aws_subnet" "public_sub" {
    count                       = length(var.public_subnet_cidr)
    vpc_id                      = aws_vpc.vpc.id
    availability_zone           = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch     = true
    cidr_block                  = var.public_subnet_cidr[count.index]
    tags = {
        "Name" = "${var.project_name}_public_sub_az${count.index}"
        "kubernetes.io/cluster/${var.k8s_cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
    }
}

resource "aws_eip" "eip" {
    count                       = length(var.public_subnet_cidr)
    vpc                         = true
}

resource "aws_nat_gateway" "natgw" {
    count                       = length(var.public_subnet_cidr)
    allocation_id               = aws_eip.eip.*.id[count.index]
    subnet_id                   = aws_subnet.public_sub.*.id[count.index]
    tags = {
        "Name" = "${var.project_name}_natgw_az${count.index}"
    }
}

resource "aws_route_table" "rt_privatesub" {
    count                       = length(var.private_subnet_cidr)
    vpc_id                      = aws_vpc.vpc.id
    route {
        cidr_block              = "0.0.0.0/0"
        nat_gateway_id          = aws_nat_gateway.natgw.*.id[count.index]
    }
    tags = {
        "Name" = "${var.project_name}_rt_privatesub${count.index}"
    }
}

resource "aws_route_table" "rt_publicsub" {
    count                       = length(var.public_subnet_cidr)
    vpc_id                      = aws_vpc.vpc.id
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id              = aws_internet_gateway.igw.id
    }
    tags = {
        "Name" = "${var.project_name}_rt_publicsub${count.index}"
    }
}

resource "aws_route_table_association" "associate_route_private_sub" {
    count                       = length(var.private_subnet_cidr)
    subnet_id                   = aws_subnet.private_sub.*.id[count.index]
    route_table_id              = aws_route_table.rt_privatesub.*.id[count.index]
}

resource "aws_route_table_association" "associate_route_public_sub" {
    count                       = length(var.public_subnet_cidr)
    subnet_id                   = aws_subnet.public_sub.*.id[count.index]
    route_table_id              = aws_route_table.rt_publicsub.*.id[count.index]
}
