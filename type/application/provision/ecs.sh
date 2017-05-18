#!/bin/bash
set -e 

# Download the ecs.config
aws s3 cp s3://immuable-infrastructure/${VERSION}/tenant/${TENANT}/ecs.config /etc/ecs/ecs.config --region us-west-2