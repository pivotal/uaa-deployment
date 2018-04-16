#!/bin/bash

set -xu

sudo route add -net 10.244.0.1/16  192.168.50.6
UAA_IP=$(bosh -e vbox -d uaa --json --column=ips --column=instance is | jq '.Tables[0].Rows[] | select(.instance | contains("uaa/"))' | jq -r .ips)
sudo echo "$UAA_IP uaa.service.uaa.internal" >> /etc/hosts

SAML_IP=$(bosh -e vbox -d uaa --json --column=ips --column=instance is | jq '.Tables[0].Rows[] | select(.instance | contains("saml/"))' | jq -r .ips)
sudo echo "$SAML_IP saml.service.uaa.internal" >> /etc/hosts

OIDC_IP=$(bosh -e vbox -d uaa --json --column=ips --column=instance is | jq '.Tables[0].Rows[] | select(.instance | contains("uaa-oidc/"))' | jq -r .ips)
sudo echo "$OIDC_IP uaa-oidc.service.uaa.internal" >> /etc/hosts
