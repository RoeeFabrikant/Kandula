output "instance_public_ip" {
    value = aws_instance.instances.*.public_ip
}

output "instance_private_ip" {
    value = aws_instance.instances.*.private_ip
}
