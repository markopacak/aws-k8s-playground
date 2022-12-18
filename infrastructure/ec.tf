module "kubeadm-token" {
  source = "scholzj/kubeadm-token/random"
}

data "cloudinit_config" "k8s_control" {
  part {
    filename     = "k8s_control_setup.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("../src/ec_user_data/k8s_control_setup.sh", { k8s_cluster_token = module.kubeadm-token.token })
  }
}

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
  key_name  = aws_key_pair.k8s_access.key_name
  user_data = data.cloudinit_config.k8s_control.rendered

  # TODO move to vpc_security_group_ids when customizing vpc
  security_groups = [aws_security_group.ec_k8s.name]
}

resource "aws_instance" "k8s_worker" {
  count = local.k8s_worker_nodes

  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name    = format("k8s-worker-%1d", count.index)
    Project = "k8s-playground"
  }
  key_name  = aws_key_pair.k8s_access.key_name
  user_data = file("../src/ec_user_data/k8s_worker_setup.sh")

  security_groups = [aws_security_group.ec_k8s.name]
}
