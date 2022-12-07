import json

import boto3

ec2 = boto3.client("ec2")

tag_filter = [{"Name": "tag:Project", "Values": ["k8s-playground"]}]


def lambda_handler(event, context):
    resp = ec2.describe_instances(Filters=tag_filter)

    ids = []
    for res in resp["Reservations"]:
        ids.extend(list(map(lambda i: i["InstanceId"], res["Instances"])))

    resp = ec2.stop_instances(InstanceIds=ids)
    return {
        "statusCode": 200,
        "body": json.dumps(f"Successfully shutdown machines {ids}"),
    }
