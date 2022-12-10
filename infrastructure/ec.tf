resource "aws_instance" "k8s_control_plane" {

  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name    = "k8s-control"
    Project = "k8s-playground"
  }

  provisioner "remote-exec" {

    connection {
       type        = "ssh"
       user        = "ubuntu"
       private_key = file(var.privatekeypath)
       host        = self.public_ip
    }
  }


  user_data = "${file("../scripts/k8s_control_setup.sh")}"


}

resource "aws_instance" "k8s_pod" {
  ami           = local.ec_ami
  instance_type = local.ec_type
  tags = {
    Name    = format("k8s-worker-%1d", count.index)
    Project = "k8s-playground"
  }

  count = local.k8s_worker_nodes

  user_data = "${file("../scripts/k8s_worker_setup.sh")}"
}
