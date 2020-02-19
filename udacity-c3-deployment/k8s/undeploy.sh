#!/bin/bash

set -e

kubectl delete -f ./deployment/backend-feed-deployment.yaml
kubectl delete -f ./deployment/backend-user-deployment.yaml
kubectl delete -f ./deployment/reverseproxy-deployment.yaml
kubectl delete -f ./deployment/frontend-deployment.yaml
