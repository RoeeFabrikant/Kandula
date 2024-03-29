module "vpc" {
    source = "./modules/vpc"

    k8s_cluster_name          = local.cluster_name
    project_name              = "kandula"
    route53_zone_name         = "kandula.internal"
    vpc_cidr                  = "10.10.0.0/16"
    private_subnet_cidr       = ["10.10.10.0/24", "10.10.11.0/24"]
    public_subnet_cidr        = ["10.10.20.0/24", "10.10.21.0/24"]

}

module "consul_servers" {
    source = "./modules/instance"

    num_of_instances             = 3
    sub_id                       = module.vpc.private_sub                                 # Don't change this line
    iam                          = module.vpc.consul_iam_profile                          # Don't change this line
    server_sg                    = [module.vpc.consul_server_sg, module.vpc.kandula_sg]   # Don't change this line
    route53_zone_id              = module.vpc.aws_route53_zone_id

    script                       = "./files/scripts/consul_server.sh"
    project_name                 = "kandula"
    server_name                  = "consul_server"
    intance_type                 = "t2.micro"
    dns_name                     = "kandula-consul-server"
    private_key_name             = var.KP

    tags = {
        consul_server = "true"
        type          = "consul_server"
        version       = "1.0"
    }
}

module "jenkins_server" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.private_sub                                  # Don't change this line
    iam                          = module.vpc.consul_iam_profile                           # Don't change this line
    server_sg                    = [module.vpc.jenkins_server_sg, module.vpc.kandula_sg]   # Don't change this line
    route53_zone_id              = module.vpc.aws_route53_zone_id

    script                       = "./files/scripts/jenkins_server.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_server"
    intance_type                 = "t2.micro"
    dns_name                     = "kandula-jenkins-server"
    private_key_name             = var.KP

    tags = {
        consul_server = "false"
        type          = "jenkins_server"
        version       = "1.0"
    }
}

module "jenkins_agent" {
    source = "./modules/instance"

    num_of_instances             = 2
    sub_id                       = module.vpc.private_sub                      # Don't change this line
    server_sg                    = [module.vpc.kandula_sg]                     # Don't change this line
    iam                          = module.vpc.admin_iam_profile_name           # Don't change this line 
    route53_zone_id              = module.vpc.aws_route53_zone_id

    script                       = "./files/scripts/jenkins_agent.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_agent"
    intance_type                 = "t2.micro"
    dns_name                     = "kandula-jenkins-agent"
    private_key_name             = var.KP

    tags = {
        consul_server = "false"
        type          = "jenkins_agent"
        version       = "1.0"
    }
}

module "mysql" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.private_sub                      # Don't change this line
    server_sg                    = [module.vpc.kandula_sg]                     # Don't change this line
    iam                          = module.vpc.consul_iam_profile               # Don't change this line 
    route53_zone_id              = module.vpc.aws_route53_zone_id

    script                       = "./files/scripts/mysql.sh"
    project_name                 = "kandula"
    server_name                  = "mysql"
    intance_type                 = "t2.micro"
    dns_name                     = "kandula-mysql-server"
    private_key_name             = var.KP

    tags = {
        consul_server = "false"
        type          = "mysql_server"
        version       = "1.0"
    }
}

module "elk" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.private_sub                      # Don't change this line
    server_sg                    = [module.vpc.kandula_sg]                     # Don't change this line
    iam                          = module.vpc.consul_iam_profile               # Don't change this line 
    route53_zone_id              = module.vpc.aws_route53_zone_id

    script                       = "./files/scripts/elk.sh"
    project_name                 = "kandula"
    server_name                  = "elk"
    intance_type                 = "t3.medium"
    dns_name                     = "kandula-elk-server"
    private_key_name             = var.KP

    tags = {
        consul_server = "false"
        type          = "elk_server"
        version       = "1.0"
    }
}

module "eks" {
    source                      = "terraform-aws-modules/eks/aws"
    version                     = "13.2.1"
    cluster_name                = local.cluster_name
    cluster_version             = var.kubernetes_version
    subnets                     = module.vpc.private_sub
    vpc_id                      = module.vpc.vpc_id
    enable_irsa                 = true

    worker_groups = [
    {
      name                          = "kandula-worker-group-1"
      instance_type                 = "t3.medium"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.vpc.all_worker_mgmt, module.vpc.kandula_sg]
    },
    {
      name                          = "kandula-worker-group-2"
      instance_type                 = "t3.medium"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.vpc.all_worker_mgmt, module.vpc.kandula_sg]
    }
  ]

}