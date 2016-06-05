#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../env
# DO NOT EDIT ABOVE THIS LINE!!!

curl -v -X GET http://${DOCKER_IP}:8123/v1/hosts/$2