
locals {
  ec_instance_type = "t3.small" # vCPU 2, mem (GiB): 2

  k8s_nodes        = 2
  k8s_pod_per_node = 1

  tags = {
    Name = "project"
    Env  = "k8s-playground"
  }
}