#!/bin/bash
set -e

git clone https://github.com/djenriquez/vault-ui.git

cd vault-ui

./run-docker-compose-dev