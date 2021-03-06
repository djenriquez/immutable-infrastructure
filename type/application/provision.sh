#!/bin/bash
set -e

export ECS_AGENT_TAG=v1.14.1

# Download all scripts and run in parallel
aws s3 cp s3://immutable-infrastructure/${VERSION}/type/${TYPE}/provision /etc/provision/ --region us-west-2 --recursive

# Loop through each script and run it
for file in /etc/provision/*.sh;
do
  . "$file"
done

cd /etc/provision
docker-compose pull
docker-compose up -d