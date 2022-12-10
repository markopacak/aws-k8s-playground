
# apply to all ec machines
resource "aws_security_group" "ec_k8s" {
  name = "k8s-playground-instances"
}

resource "aws_security_group_rule" "allow_ssh" {
  from_port = 22
  to_port   = 22

  protocol          = "tcp"
  security_group_id = aws_security_group.ec_k8s.id
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  from_port = 0
  to_port   = 0

  protocol          = "-1"
  security_group_id = aws_security_group.ec_k8s.id
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_intra_cluster" {
  from_port = 0
  to_port   = 0

  protocol                 = "-1"
  source_security_group_id = aws_security_group.ec_k8s.id
  security_group_id        = aws_security_group.ec_k8s.id
  type                     = "ingress"
}
