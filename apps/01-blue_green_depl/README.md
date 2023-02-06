# k8s playground

Extremely simply project that simulates a blue-green deployment using nginx web-servers.

**TODO** I need to update this with some custom services!

## Set up

Create cloud environment from the `infrastructure` folder:

    terraform apply -var-file="../apps/01-blue_green_depl/env.tfvars"

Connect via SSH to the control pane and copy the YAML files.

Start by running a blue deployment:

    kubectl apply -f blue-deployment.yml

Verify the deployment with `kubectl get deployments`.

Run the service:

    kubectl apply -f depl-test.yml

Get the service IP addr `kubectl get services` and then run curl:

    curl <IP_ADDR>

You should see this message: `I'm blue!!`

Finally, you can deploy the green deployment and edit the service to reach the new deployment:

    kubectl apply -f green-deployment.yml
    kubectl edit service/bluegreen-test-svc

Replace all _blue_ mentions with _green_ and then call the service again.

    curl <IP_ADDR>

You should now see this message: `I'm green!!`

## Destroy environment

Destroy environment from the `infrastructure` folder:

    terraform destroy
