#!/usr/bin/env bash

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -r|--replicas)
    REPLICAS="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
echo Scaling Kubernetes Replicas to = "${REPLICAS}"
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi

kubectl scale rc ccc-api --replicas="${REPLICAS}"