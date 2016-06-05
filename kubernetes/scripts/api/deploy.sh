#!/usr/bin/env bash

kubectl create -f - << EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: ccc-api
  labels:
    k8s-app: ccc-api
    version: 1.1.0
    kubernetes.io/cluster-service: "true"
spec:
  replicas: 1
  selector:
    k8s-app: ccc-api
    version: 1.1.0
    kubernetes.io/cluster-service: "true"
  template:
    metadata:
      labels:
        k8s-app: ccc-api
        version: 1.1.0
        kubernetes.io/cluster-service: "true"
    spec:
      containers:
      - name: ccc-api
        image: robgmills/ccc-api:1.1.0
        ports:
        - containerPort: 9090
        livenessProbe:
          httpGet:
            path: /api/health-check
            port: 9090
          initialDelaySeconds: 10
          timeoutSeconds: 1
EOF

kubectl expose rc ccc-api --port=9090 --target-port=9090 --type=NodePort
