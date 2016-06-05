#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../env
source ${DIR}/env
# DO NOT EDIT ABOVE THIS LINE!!!

if [ -n "$1" ]; then
    curl -H "Content-Type: application/json" -X POST --data @${DIR}/marathon.$1.template.json ${API_ROOT}
else
    echo "ERROR: Did not specify application to scale! (i.e. api|api-v1_1_0|load-balancer|mesos-dns)"
fi