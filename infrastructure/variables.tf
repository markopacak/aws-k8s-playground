
locals {
  ec_type = "t3.small"              # vCPU 2, mem (GiB): 2
  ec_ami  = "ami-065deacbcaac64cf2" # Ubuntu AMI
}

variable "ec_public_key_file" {
  type    = string
  default = "~/.ssh/k8s_playground.pub"
}

variable "k8s_worker_nodes" {
  type    = number
  default = 3
}

variable "ec_automatic_shutdown" {
  # whether to deploy a lambda that automatically shuts down at midnight
  type    = bool
  default = true
}
