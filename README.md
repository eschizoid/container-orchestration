# Container Orchestration
## Chicago Coder Conference June 6-8, 2016

# Pre-requisites

We've built the workshop/demo for our presentation on Docker. Yes, that means you'll be running Docker in Docker.

Make sure you have followed the instructions to install the [latest tools from Docker][docker-toolbox] and have a working
Docker daemon.

It may also be helpful to install Java and Maven, if you want to build everything from source. If not, that's ok, all of
the applications and Docker containers have been pre-built and published to [Docker Hub][docker-hub].

# Slide Deck
[The presentation slide deck can be found here.](http://bit.ly/container-orchestration-slides) 

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
brew install kubernetes-cli
```

#### Windows

At the time of writing this, there was no official support for `kubectl` on Windows. You will have to ssh into the container
to run commands.

### Create docker machine (OS X and Windows)

In case you don't have docker-machine, just execute the following helper script to create one:

```
./kubernetes/docker-machine-kubernestes.sh
```

### Run Kubernetes Cluster

The main scripts for setting a Kubernetes cluster within Docker is `kube-up.sh`. In case you wanna destroy Kubernetes
cluster, you might end up using `kube-down.sh`

In order to get started you need to do is execute following command, that will setup Kubernetes infrastructure:
```
./kubernetes/kube-up.sh
```

This wrapper script uses the following shells in oder to setup all Kubernetes components(replication controllers, services,
namespaces, etc):
```
./kubernetes/scripts/activate-dns.sh
./kubernetes/scripts/activate-kube-ui.sh
./kubernetes/scripts/create-kube-system-namespace.sh
./kubernetes/scripts/docker-machine-port-forwarding.sh
./kubernetes/scripts/wait-for-kubernetes.sh
```

If everything was installed correctly, Kubernetes UI should be available [here](http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui/).

### Replication Controller

Once Kubernetes infrastructure is up and running, we need to create a Replication Controller in order to expose the API.
To do that issue the following command:

```
./kubernetes/scripts/api/deploy.sh
```

### Hit the API

We can hit the API by making requests through the load balancer.

                                                                     +-------+
                                                                     |       |
                                                           +---------> API(1)|
       +---------+         +------------------------+      |         |       |
       |         |         |                        |      |         +-------+
       | kubectl +---------> Replication Controller +------+
       |         |         |                        |      |         +-------+
       +---------+         +------------------------+      |         |       |
                                                           +---------> API(2)|
                                                                     |       |
                                                                     +-------+


First get Kubernetes node port using the following command:

```
kubectl get -o yaml service/ccc-api | grep nodePort
```

Using the port from the previous step, run the command (remember to substitute the place holders):

```
curl -X GET http://{DOCKER_IP}:{KUBERNETES_NODE_PORT}/api/hello
```

or use the script that polls the API

```
./kubernetes/scripts/kubernetes/hello.sh
```

### Scale the API

Now that Replication controller is ready, is time to scale the application. Open a second terminal and issue the  following
command
```
./kubernetes/scripts/kubernetes/scale.sh -r <number of replicas>
```

Observe how the response changes depending on how Kubernetes Replication controller balances the traffic.

**Note**
You can scale the number of replicas to whatever number you want to.

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
kubectl get services
```

## Marathon/Mesos

You have to specify `DOCKER_IP` env variable in order to make Mesos work
properly. The default value is `127.0.0.1` and it should work if you have
Docker daemon running locally (i.e. you're on a Linux machine)

If you use `docker-machine` you can do the following, assuming `default` is your
machine's name:

```
export DOCKER_IP=$(docker-machine ip default)
```

Run your cluster in the background:

```
docker-compose up -d
```

That deploys a very basic environment consisting of:
 
* A single Mesos Master node - addressable at [http://$DOCKER_IP:5050](http://192.168.99.100:5050)
* A single Mesos Slave node
* An instance of Zookeeper
* A instance of the Marathon UI - addressable at [http://$DOCKER_IP:8080](http://192.168.99.100:8080)

With this infrastructure alone, we can deploy and run a number of different containers and frameworks.
But in order to build a resilient system, we're going to want to deploy a load balancer for discovery 
of and to properly route traffic to instances of our API.  We're going to deploy the load balancer on 
Mesos using Marathon so that Marathon can automatically restart the load balancer if it goes down. 

You can deploy the supporting infrastructure using on of two methods:

### Shell Scripts

Run the following scripts:

```
./marathon/scripts/marathon/deploy.sh load-balancer
./marathon/scripts/marathon/deploy.sh api
```

That script simply loads the template JSON from the same directory that the script lives in, and `POST`s it to 
[Marathon's REST API](https://mesosphere.github.io/marathon/docs/rest-api.html).

The HAProxy load balancer is now addressable at [http://$DOCKER_IP:9090/haproxy?stats](http://192.168.99.100:9090/haproxy?stats)

### The Marathon UI

Navigate to the Marathon UI ([http://$DOCKER_IP](http://192.168.99.100:8080)) and click the button labeled "Create Application".
Set the fields appropriately as defined in the JSON templates located in the directory `marathon/scripts/marathon` or toggle the
JSON mode switch in the top right corner and copy/paste the template.  Click the button to save and deploy the configuration.

### Hit the API

We can hit the API by making requests through the load balancer.

                                                               +-------+
                                                               |       |
                                                     +---------> API(1)|
       +----------+         +---------------+        |         |       |
       |          |         |               |        |         +-------+
       |   Curl   +---------> Load Balancer +--------+
       |          |         |               |        |         +-------+
       +----------+         +---------------+        |         |       |
                                                     +---------> API(2)|
                                                               |       |
                                                               +-------+


Run the command 

```
curl -X GET http://${DOCKER_IP}:10000/api/hello
```

or use the script that polls the API

```
./marathon/scripts/marathon/hello.sh
```

Notice how the part of the response that contains the host information changes with each request as the load balancer 
round-robins through the available instances.

### Scale the API

Open a second terminal and issue the following command:

```
./marathon/scripts/marathon/scale.sh api <number of instances>
```

Observe how the response changes depending on how HA Proxy balances the traffic.

**Note**
You can scale the number of replicas to whatever number you want to.

## Help!  I screwed everything up! What do I do?

Simply kill your cluster and wipe all state to start fresh:

```
docker-compose stop && docker-compose rm -f -v
```

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
