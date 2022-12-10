#! /bin/bash

sudo apt-get update

inst_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
inst_name=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$inst_id" "Name=key,Values=Name" --output text | cut -f5)

sudo hostnamectl set-hostname $inst_name
