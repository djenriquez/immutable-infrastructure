#!/bin/bash

# Remove unnecessary files
rm -rf /etc/immutable-infrastructure/.git
rm -rf /etc/immutable-infrastructure/.gitignore
rm -rf /etc/immutable-infrastructure/Dockerfile
rm -rf /etc/immutable-infrastructure/README.md
rm -rf /etc/immutable-infrastructure/src/
rm -rf /etc/immutable-infrastructure/shippable.yml
rm -rf /etc/immutable-infrastructure/examples/
rm -rf /etc/immutable-infrastructure/terraform/

# Perform sync
aws s3 sync /etc/immutable-infrastructure/ s3://immutable-infrastructure/${BUCKET_PATH}/ --region us-west-2 --delete \
--exclude "*.key" \
--exclude "*.pem"
