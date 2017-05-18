#!/bin/bash

# AWS Metadata
export EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export IPV4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# Fetch Tagged Metadata
export TYPE=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Type" --region us-east-2 | jq -r .Tags[0].Value`
export TENANT=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Tenant" --region us-east-2 | jq -r .Tags[0].Value`
export ENVIRONMENT=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Environment" --region us-east-2 | jq -r .Tags[0].Value`

# Fetch infrastructure version from Consul
export VERSION=`curl consul.immutable-infrastructure.djenriquez.com/v1/kv/provisioning/$TENANT/$TYPE/version?raw`
if [[ -z $VERSION ]]; then
  export VERSION=dev
fi

# Download start up script
aws s3 cp s3://immutable-infrastructure/$VERSION/type/$TYPE/provision.sh /tmp/provision.sh --region us-east-2

# Make script executable
chmod a+x /tmp/provision.sh

# Execute start-up script
. /tmp/provision.sh