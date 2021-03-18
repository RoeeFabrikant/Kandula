resource "aws_instance" "instances" {
    count                     = var.num_of_instances
    subnet_id                 = var.sub_id[count.index%2]
    ami                       = data.aws_ami.ubuntu.id
    instance_type             = var.intance_type
    key_name                  = var.private_key_name
    vpc_security_group_ids    = var.server_sg
    iam_instance_profile      = var.iam != "" ? var.iam : null
    user_data                 = file(var.script)
    tags = merge(
      {
        Name          = "${var.project_name}_${var.server_name}_${count.index}"
        project       = var.project_name
      },
      var.tags
    ) 
}

resource "aws_route53_record" "route53_record" {
  count   = var.num_of_instances
  zone_id = var.route53_zone_id
  name    = "${var.dns_name}_${count.index+1}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.instances.*.private_ip[count.index%2]]
}
