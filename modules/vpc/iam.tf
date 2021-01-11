## CONSUL_IAM_ROLE

resource "aws_iam_role" "consul_iam_role" {
  name                  = "consul_iam_role"
  assume_role_policy    = file("./files/iam/consul_iam_role.json")
}

resource "aws_iam_policy" "consul_iam_policy" {
  name                  = "consul_iam_policy"
  description           = "Allows Consul nodes to describe instances for joining."
  policy                = file("./files/iam/consul_iam_policy.json")
}

resource "aws_iam_policy_attachment" "consul-iam_attachment" {
  name                  = "consul-iam_attachment"
  roles                 = [aws_iam_role.consul_iam_role.name]
  policy_arn            = aws_iam_policy.consul_iam_policy.arn
}

resource "aws_iam_instance_profile" "consul-iam" {
  name                  = "consul-iam"
  role                  = aws_iam_role.consul_iam_role.name
}

resource "aws_iam_role" "admin_iam" {
  name                  = "admin-full-access"
  assume_role_policy    = file("./files/iam/AdminFullAccess-iam.json")
}

resource "aws_iam_role_policy" "admin_policy" {
  name                  = "admin-full-access"
  role                  = aws_iam_role.admin_iam.name
  policy                = file("./files/iam/AdminFullAccess-policy.json")
}

resource "aws_iam_instance_profile" "admin_profile" {
  name                  = "admin-full-access"
  role                  = aws_iam_role.admin_iam.name
}