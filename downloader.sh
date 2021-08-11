#!/bin/bash

set -v -e

export LATEST_GOST_VERSION=$(curl --silent "https://api.github.com/repos/ginuerzh/gost/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -c 2-)
curl -o gost.gz -sL https://github.com/ginuerzh/gost/releases/download/v${LATEST_GOST_VERSION}/gost-linux-amd64-${LATEST_GOST_VERSION}.gz 
gunzip gost.gz 
curl -sL -o /update-resolv-conf.sh https://github.com/masterkorp/openvpn-update-resolv-conf/raw/master/update-resolv-conf.sh