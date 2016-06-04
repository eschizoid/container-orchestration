#!/usr/bin/env bash

kubectl run ccc-api --image=robgmills/ccc-api:1.0.0 --port=9090

kubectl expose rc ccc-api --port=9090 --target-port=9090 --type=NodePort

kubectl get -o yaml service/ccc-api | grep nodePort

kubectl scale rc ccc-api --replicas=5

