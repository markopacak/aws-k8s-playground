import json

import boto3

ec2 = boto3.client("ec2")

tag_filter = [{"Name": "tag:Project", "Values": ["k8s-playground"]}]


def lambda_handler(event, context):
    resp = ec2.describe_instances(Filters=tag_filter)
    ids = [
        i["InstanceId"] for r in resp["Reservations"] for i in r["Instances"]
    ]

    resp = ec2.stop_instances(InstanceIds=ids)
    return {
        "statusCode": resp["ResponseMetadata"]["HTTPStatusCode"],
        "body": json.dumps(f"Successfully shutdown machines {ids}"),
    }
