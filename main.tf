module "vpc" {
    source = "./modules/vpc"

    project_name              = "kandula"
    vpc_cidr                  = "10.10.0.0/16"
    private_subnet_cidr       = ["10.10.10.0/24", "10.10.11.0/24"]
    public_subnet_cidr        = ["10.10.20.0/24", "10.10.21.0/24"]
}

module "consul_servers" {
    source = "./modules/instance"

    num_of_instances             = 3
    sub_id                       = module.vpc.private_sub                                  # Don't change this line
    iam                          = module.vpc.consul_iam_profile                          # Don't change this line
    server_sg                    = [module.vpc.consul_server_sg, module.vpc.kandula_sg]   # Don't change this line

    script                       = "./files/scripts/consul_server.sh"
    project_name                 = "kandula"
    server_name                  = "consul_server"
    intance_type                 = "t2.micro"
    private_key_name             = "<YOUR-PK-NAME-HERE>"

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

    script                       = "./files/scripts/jenkins_server.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_server"
    intance_type                 = "t2.micro"
    private_key_name             = "<YOUR-PK-NAME-HERE>"

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
    iam                          = module.vpc.consul_iam_profile               # Don't change this line 

    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_agent"
    intance_type                 = "t2.micro"
    private_key_name             = "<YOUR-PK-NAME-HERE>"

    tags = {
        consul_server = "false"
        type          = "jenkins_agent"
        version       = "1.0"
    }
}

module "bastion_host" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.public_sub                       # Don't change this line
    server_sg                    = [module.vpc.ssh_sg, module.vpc.kandula_sg]  # Don't change this line

    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "bastion_host"
    intance_type                 = "t2.micro"
    private_key_name             = "<YOUR-PK-NAME-HERE>"
    iam                          = ""

    tags = {
        consul_server = "false"
        type          = "bastion_host"
        version       = "1.0"
    }
}

module "alb" {
    source = "./modules/alb"

    project_name                 = "kandula"
    subnets                      = module.vpc.public_sub
    security_groups              = module.vpc.alb_sg 
    vpc                          = module.vpc.vpc_id
    instances_id_jenkins         = module.jenkins_server.instance_id
    instances_id_consul          = module.consul_servers.instance_id
}