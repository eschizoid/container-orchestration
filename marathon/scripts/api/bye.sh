#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../env
source ${DIR}/env
# DO NOT EDIT ABOVE THIS LINE!!!

curl -v -X GET ${API_ROOT}/bye