#!/bin/bash

echo "Creating a local Kubernetes cluster..."

# Creating a Minikube cluster via Docker driver
minikube start --driver=docker

# Checking  the status of nodes in cluster
kubectl get nodes

echo "Cluster was successfully created!"
