import json

import boto3

ec2 = boto3.client("ec2")

ec_filters = [
    {"Name": "tag:Project", "Values": ["k8s-playground"]},
    {"Name": "instance-state-name", "Values": ["pending", "running"]},
]


def lambda_handler(event, context):
    resp = ec2.describe_instances(Filters=ec_filters)
    ids = [
        i["InstanceId"] for r in resp["Reservations"] for i in r["Instances"]
    ]

    resp = ec2.stop_instances(InstanceIds=ids)
    return {
        "statusCode": resp["ResponseMetadata"]["HTTPStatusCode"],
        "body": json.dumps(f"Successfully shutdown machines {ids}"),
    }
