resource "aws_key_pair" "k8s_access" {
  key_name   = "k8s_access"
  public_key = file(var.ec_public_key_file)
}


resource "aws_instance" "k8s_control_plane" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name    = "k8s-control"
    Project = "k8s-playground"
  }
  key_name = aws_key_pair.k8s_access.key_name

  user_data = file("../scripts/k8s_control_setup.sh")

  # TODO move to vpc_security_group_ids when customizing vpc
  security_groups = [aws_security_group.ec_k8s.name]
}

resource "aws_instance" "k8s_worker" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name    = format("k8s-worker-%1d", count.index)
    Project = "k8s-playground"
  }
  key_name = aws_key_pair.k8s_access.key_name

  count = local.k8s_worker_nodes

  user_data = file("../scripts/k8s_worker_setup.sh")

  security_groups = [aws_security_group.ec_k8s.name]
}
