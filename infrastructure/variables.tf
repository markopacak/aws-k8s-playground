
locals {
  ec_type = "t3.small"              # vCPU 2, mem (GiB): 2
  ec_ami  = "ami-065deacbcaac64cf2" # Ubuntu AMI

  k8s_worker_nodes = 1
}

variable "ec_public_key_file" {
  type    = string
  default = "~/.ssh/k8s_playground.pub"
}
