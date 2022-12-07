import json

import boto3


def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    resp = ec2.describe_instances(Filters=[{"Name": "tag:k8s-playground"}])
    print(resp)
    ids = []
    resp = ec2.stop_instances(InstanceIds=ids)  # TODO
    print(resp)
    return {
        "statusCode": 200,
        "body": json.dumps(f"Successfully shutdown machines {ids}"),
    }
