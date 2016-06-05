#!/usr/bin/env bash

kubectl get -o yaml service/ccc-api | grep nodePort | awk -F'- nodePort: ' '{print $2}'

