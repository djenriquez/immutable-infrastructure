#!/bin/bash

export IPV4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export DATACENTER=$TENANT
export CONSUL_SIZE=3
export CONSUL_TAG=0.8.2

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