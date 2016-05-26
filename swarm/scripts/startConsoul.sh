#!/usr/bin/env bash


eval $(docker-machine env consul-machine)
eval "$(docker-machine env --swarm swarm-master)"
docker run swarm list consul://$(docker-machine ip consul-machine):8500