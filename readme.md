

# Technical Devops Challenge

This repo contains a small "Hello World" webserver which simulates a small microservice

## Tasks


 - Create a docker image for the microservice. The smaller the image, the better.
    [Michael] Refer to Dockerfile, used multi-stage builds.
 - From security perspective, make sure that the generated docker image has a small attack surface
    [Michael] Refer to Dockerfile
 - Create all required resources in Kubernetes to expose the microservice to the public. Make sure that the microservice has access to a volume mounted in /tmp for storing temp data.
    [Michael] Refer to k8s-tech-challenge.yaml, the resources created includes: Deployment, ConfigMap, HPA, Service, Ingress
 - Use MESSAGES env variable to configure the message displayed by the server
    [Michael] Refer to k8s-tech-challenge.yaml, added env "MESSAGES", which reads value from ConfigMap message-config, in container tech-challenge's spec.
 - Make sure that the health of the microservice is monitored from Kubernetes perspective
    [Michael] Added readiness and liveness probes in k8s-tech-challenge.yaml
 - Security wise, try to follow the best practices securing all the resources in Kubernetes when possible
 - Create a K8S resource for scale up and down the microservice based on the CPU load
    [Michael] Refer to resource HPA in k8s-tech-challenge.yaml
 - Create a Jenkins pipeline for deploying the microservice.
    [Micahel] Refer to Jenkinsfile.
 - Describe how to retrieve metrics from the microservice like CPU usage, memory usage...
    [Michael] We can use resource metrics pipeline or full metrics pipeline to collect the monitoring metrics like CPU, memory usage.
    The resource metrics pipeline provides a limited set of metrics related to cluster components such as the HPA controller, as well as the "kubectl top" utility. These metrics are collected by the lightweight, short-term, in-memory metrics-server and are exposed via the metrics.k8s.io API, 
    the metrics-server discovers all nodes on the cluster and queries each node’s kubelet for CPU and memory usage. The kubelet fetches individual container usage statistics from the container runtime through the container runtime interface. It then exposes the aggregated pod resource usage statistics through the metrics-server Resource Metrics API.
    A full metrics pipeline gives us access to richer metrics. Kubernetes can respond to these metrics by automatically scaling or adapting the cluster based on its current state, using mechanisms such as the HPA. The monitoring pipeline fetches metrics from the kubelet and then exposes them to Kubernetes via an adapter by implementing either the custom.metrics.k8s.io or external.metrics.k8s.io API.
    Prometheus can natively monitor Kubernetes, nodes, and Prometheus itself.
 - Describe how to retrieve the logs from the microservice and how to store in a central location
    [Michael] The easiest and most embraced logging method for microservices (or containerized applications) is to write to stdout and stderr, which is handled and redirected somewhere by a container engine, e.g., the docker container engine redirects those two streams to a logging driver (such as fluentd).
    We can use a node-level logging agent that on each node (implemented as a DaemonSet in k8s). The logging agent is a dedicated tool that exposes logs or pushes logs to a backend (a central locaiton). Commonly, the logging agent is a container that has access to a directory with log files from all of the application containers on that node,
    or we can include a dedicated sidecar container for logging in an application container, either the sidecar container streams application logs to its own stdout, or the sidecar container runs a logging agent, which is configured to pick up logs from an application container and to expose or push logs to backend. 
    
