output "consul_server_public_address" {
    value = module.consul_servers.instance_public_ip
}

output "consul_server_private_address" {
    value = module.consul_servers.instance_private_ip
}

output "jenkins_server_public_address" {
    value = module.jenkins_server.instance_public_ip
}

output "jenkins_server_private_address" {
    value = module.jenkins_server.instance_private_ip
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

output "alb_dns_name" {
    value = module.alb.alb_dns_name
}

output "eks_cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "admin_iam_profile_arn" {
  value       = module.vpc.admin_iam_profile_arn
}