resource "aws_security_group" "node_group_sg" {
  name = var.node_group_name
}

resource "aws_security_group_rule" "self" {
  from_port         = 0
  protocol          = "TCP"
  to_port           = 65535
  type              = "ingress"
  self              = true
  security_group_id = aws_security_group.node_group_sg.id
}

resource "aws_security_group_rule" "outbound_internet" {
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.node_group_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}