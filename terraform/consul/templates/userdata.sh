#!/bin/bash

export IPV4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export DATACENTER=demo
export TENANT=demo
export TYPE=consul
export CONSUL_SIZE=3

docker pull consul:0.8.3

docker run -d \
--name consul \
--net host \
-e CONSUL_LOCAL_CONFIG='
{
    "skip_leave_on_interrupt": false, 
    "leave_on_terminate": true
}' \
consul:0.8.3 \
agent -server -ui -client 0.0.0.0 -bind $IPV4 -datacenter $DATACENTER -bootstrap-expect $CONSUL_SIZE -retry-join-ec2-tag-key Tenant -retry-join-ec2-tag-value $DATACENTER -node-meta server:$TENANT-$TYPE