resource "aws_alb" "alb" {
  name                  = "${var.project_name}-alb"
  internal              = false
  load_balancer_type    = "application"
  security_groups       = [var.security_groups]
  subnets               = var.subnets
}

resource "aws_alb_listener" "alb_listener_jenikins" {
  load_balancer_arn     = aws_alb.alb.arn
  port                  = 8080

  default_action {
    type                = "forward"
    target_group_arn    =  aws_alb_target_group.alb_target_jenkins.arn
  }
}

resource "aws_alb_listener" "alb_listener_consul" {
  load_balancer_arn     = aws_alb.alb.arn
  port                  = 8500

  default_action {
    type                = "forward"
    target_group_arn    =  aws_alb_target_group.alb_target_consul.arn
  }
}

resource "aws_alb_target_group" "alb_target_jenkins" {
    name                = "${var.project_name}-alb-target-group-jenkins"
    port                = 8080
    protocol            = "HTTP"
    vpc_id              = var.vpc

    health_check {
      enabled = true
      path    = "/login"
    }
}

resource "aws_alb_target_group" "alb_target_consul" {
    name                = "${var.project_name}-alb-target-group-consul"
    port                = 8500
    protocol            = "HTTP"
    vpc_id              = var.vpc

    health_check {
      enabled = true
      path    = "/ui/kandula/services"
    }
}

resource "aws_alb_target_group_attachment" "alb_target_attachment_jenkins" {
  count                 = length(var.instances_id_jenkins)
  target_group_arn      = aws_alb_target_group.alb_target_jenkins.arn
  target_id             = var.instances_id_jenkins[count.index]
}

resource "aws_alb_target_group_attachment" "alb_target_attachment_consul" {
  count                 = length(var.instances_id_consul)
  target_group_arn      = aws_alb_target_group.alb_target_consul.arn
  target_id             = var.instances_id_consul[count.index]
}