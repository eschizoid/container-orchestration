#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../env
source ${DIR}/env
# DO NOT EDIT ABOVE THIS LINE!!!

while true
do
    curl -X GET -w "\n" ${API_ROOT}/hello
    sleep 1
done
