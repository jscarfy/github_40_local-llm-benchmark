#!/bin/bash
# Kubernetes multi-region deployment
kubectl config use-context us-west
kubectl apply -f ./multi-region/k8s-deployment.yaml
kubectl config use-context eu-central
kubectl apply -f ./multi-region/k8s-deployment.yaml
