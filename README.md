# aws-k8s-playground
My infrastructure set-up for playing and testing apps with Kubernetes on AWS.

This is still in progress! Instructions will follow soon.


## Set up

On the AWS console, generate credentials and then configure locally as described [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build).

Generate an _ed25519_ SSH key named `k8s_playground` and store it in the `~/.ssh`.

Inside `infrastructure/` create a `local.tfvars` file and add configuration, e.g.

    k8s_worker_nodes      = 5
    ec_automatic_shutdown = true

Run `terraform init` to

Generate / destroy infrastructure with:

    terraform apply -var-file="local.tfvars"
    terraform destroy
