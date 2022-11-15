#!/usr/bin/env bash

set -e

yum install -y git docker htop

curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

systemctl enable docker
systemctl start docker

git clone https://github.com/stephan-dowding/CodeWhispers.git
cd CodeWhispers/docker

if [ "${public_hostname}" == "" ]; then
  PUBLIC_HOSTNAME="$(curl -4 ifconfig.co)" docker-compose up
else
  PUBLIC_HOSTNAME="${public_hostname}" PORT=80 docker-compose up
fi
