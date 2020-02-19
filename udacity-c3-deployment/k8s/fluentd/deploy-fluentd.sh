#!/bin/bash

set -e

kubectl apply -f ../namespace/cloudwatch-namespace.yaml

kubectl create configmap cluster-info \
--from-literal=cluster.name=udagram \
--from-literal=logs.region=ap-southeast-2 -n amazon-cloudwatch

kubectl apply -f fluentd.yml
