output "consul_server_public_address" {
    value = module.consul_servers.instance_public_ip
}

output "consul_server_private_address" {
    value = module.consul_servers.instance_private_ip
}

output "jenkins_server_public_address" {
    value = module.jenkins_servers.instance_public_ip
}

output "jenkins_server_private_address" {
    value = module.jenkins_servers.instance_private_ip
}

output "jenkins_agent_public_address" {
    value = module.jenkins_agent.instance_public_ip
}

output "jenkins_agent_private_address" {
    value = module.jenkins_agent.instance_private_ip
}

output "bastion_host_public_address" {
    value = module.bastion_host.instance_public_ip
}

output "bastion_host_private_address" {
    value = module.bastion_host.instance_private_ip
}