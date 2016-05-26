#!/usr/bin/env bash

docker-machine create -d virtualbox --virtualbox-disk-size "5000" --swarm --swarm-master --swarm-discovery="consul://$(docker-machine ip consul-machine):8500" --engine-opt="cluster-store=consul://$(docker-machine ip consul-machine):8500" --engine-opt="cluster-advertise=eth1:2376" swarm-master
