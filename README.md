# Container Orchestration
## Chicago Coder Conference June 6-8, 2016

# Pre-requisites

We've built the workshop/demo for our presentation on Docker.  Yes, that means you'll be running Docker in Docker.  

Make sure you have followed the instructions to install the [latest tools from Docker][docker-toolbox] and have a working
Docker daemon.

It may also be helpful to install Java and Maven, if you want to build everything from source.  If not, that's ok, all of
the applications and Docker containers have been pre-built and published to [Docker Hub][docker-hub].

# Getting started
## Kubernetes
The firs thing you need to do is install Kubernetes command line interface (`kubectl`). This will allow you to communicate
with all different Kubernetes components such as: pods, services and nodes.

### Install kubectl
#### Linux
```
curl -O https://storage.googleapis.com/bin.kuar.io/linux/kubectl
chmod +x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```
#### OS X
```
brew install kubectl
```

#### Windows
At the time or writing this, there was nto official support for `kubectl` on Windows. You will have to ssh into the container
to run commands.

### Create docker machine (OS X and Windows)
In case you don't have docker-machine, just execute the following helper script to create one

```
./docker-machine-kubernestes.sh
```

### Run Kubernetes Cluster
The main scripts for setting a Kubernetes cluster within Docker is `kubernestes-up.sh`. In case you wanna destroy Kubernetes
cluster, you might end up using `kubernest-down.sh`

In order to get started the only thing you need to do is execute
```
`./kubernestes-up.sh
```

This wrapper script uses the following scripts in oder to setup all Kubernetes component:
```
activate-dns.sh
activate-kube-ui.sh
create-kube-system-namespace.sh
docker-machine-port-forwarding.sh
wait-for-kubernetes.sh
```
### Explore the kubectl CLI

Check the health status of the cluster components:

```
kubectl get cs
```

List pods:

```
kubectl get pods
```

List nodes:

```
kubectl get nodes
```

List services:

```
kubectl get
```

## Marathon/Mesos

You have to specify `DOCKER_IP` env variable in order to make Mesos work
properly. The default value is `127.0.0.1` and it should work if you have
Docker daemon running locally.

If you use `docker-machine` you can do the following, assuming `dev` is your
machine's name:

```
export DOCKER_IP=$(docker-machine ip default)
```

Run your cluster in the background (equivalent to `docker-compose up -d`):

```
docker-compose up
```

That's it, use the following URLs:

* http://$DOCKER_IP:5050/ for Mesos master UI
* http://$DOCKER_IP:5051/ for the first Mesos slave UI
* http://$DOCKER_IP:5052/ for the second Mesos slave UI
* http://$DOCKER_IP:8080/ for Marathon UI
* http://$DOCKER_IP:8888/ for Chronos UI


To kill your cluster and wipe all state to start fresh:

```
docker-compose stop && docker-compose rm -f -v
```

## Docker Swarm

# Building from scratch

To build this source code yourself, you need to have Java and Maven installed.

Simply run:

```
mvn clean install
```

## Source Description

### api

The `api` module contains the source code to build and deploy our simple "Hello World" API application and the container
that runs that application.  It's built using our favorite enterprise integration framework, Apache Camel, on top of 
Fabric8.

[docker-toolbox]: https://www.docker.com/products/docker-toolbox
[docker-hub]: https://hub.docker.com


