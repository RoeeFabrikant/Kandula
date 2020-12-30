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
    sub_id                       = module.vpc.private_sub           # Don't change this line
    server_sg                    = module.vpc.sg                    # Don't change this line
    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "consul_server"
    intance_type                 = "t2.micro"
    private_key_name             = "my-opsschool-kp"
    iam                          = ""
}

module "jenkins_servers" {
    source = "./modules/instance"

    num_of_instances             = 2
    sub_id                       = module.vpc.private_sub           # Don't change this line
    server_sg                    = module.vpc.sg                    # Don't change this line
    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_server"
    intance_type                 = "t2.micro"
    private_key_name             = "my-opsschool-kp"
    iam                          = ""
}

module "jenkins_agent" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.private_sub           # Don't change this line
    server_sg                    = module.vpc.sg                    # Don't change this line
    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "jenkins_agent"
    intance_type                 = "t2.micro"
    private_key_name             = "my-opsschool-kp"
    iam                          = ""
}

module "bastion_host" {
    source = "./modules/instance"

    num_of_instances             = 1
    sub_id                       = module.vpc.public_sub           # Don't change this line
    server_sg                    = module.vpc.sg                   # Don't change this line
    script                       = "./files/scripts/empty.sh"
    project_name                 = "kandula"
    server_name                  = "bastion_host"
    intance_type                 = "t2.micro"
    private_key_name             = "my-opsschool-kp"
    iam                          = ""
}