#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../env
source ${DIR}/env
# DO NOT EDIT ABOVE THIS LINE!!!

instances=0
if [ -n "$2" ]; then
    instances=$2
fi

if [ -n "$1" ]; then
    curl -H "Content-Type: application/json" -X PUT --data "{ \"instances\": $instances}" ${API_ROOT}/$1
else
    echo "ERROR: Did not specify application to deploy! (i.e. api|load-balancer|mesos-dns)"
fi