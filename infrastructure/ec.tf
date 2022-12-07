resource "aws_instance" "k8s_control_plane" {

  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name = "k8s-control"
  }
}

resource "aws_instance" "k8s_pod" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name = format("k8s-pod-%1d", count.index)
  }

  count = local.k8s_worker_nodes
}
