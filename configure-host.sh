#!/bin/bash

UAA_IP=$(bosh -e vbox -d uaa --json --column=ips --column=instance is | jq '.Tables[0].Rows[] | select(.instance | contains("uaa"))' | jq -r .ips)
sudo echo "$UAA_IP uaa-minimal.bosh-lite.com" >> /etc/hosts
