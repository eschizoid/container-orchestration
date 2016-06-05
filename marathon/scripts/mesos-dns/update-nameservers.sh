#!/usr/bin/env bash
if [ -n "$1" ]; then
    DOCKER_IP=$(docker-machine ip default)
else
    DOCKER_IP=$(docker-machine ip $1)
fi
echo "nameserver ${DOCKER_IP}"  | sudo tee -a /etc/resolv.conf