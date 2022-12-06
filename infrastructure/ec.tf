resource "aws_instance" "k8s-control-plane" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags          = local.tags

}

resource "aws_instance" "k8s-pod" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags          = local.tags

  count = local.k8s_worker_nodes
}
