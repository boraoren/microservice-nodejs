#!/bin/bash

set -e

#CONFIGURATION
ENV_CONFIGMAP_FILE="./configmap/env-configmap.yaml"
ENV_SECRET_FILE="./secret/env-secret.yaml"
AWS_SECRET_FILE="./secret/aws-secret.yaml"
DB_USER_NAME=$(echo -n "${POSTGRESS_USERNAME}" | base64)
DB_USER_PASSWORD=$(echo -n "${POSTGRESS_PASSWORD}" | base64)

#CONFIG MAP
env_configmap=$(sed "s/{{AWS_BUCKET}}/$AWS_BUCKET/g;
s/{{AWS_PROFILE}}/$AWS_PROFILE/g;s/{{AWS_REGION}}/$AWS_REGION/g;
s/{{POSTGRESS_DB}}/$POSTGRESS_DB/g;s/{{POSTGRESS_HOST}}/$POSTGRESS_HOST/g;
s,{{URL}},$URL,g" < "$ENV_CONFIGMAP_FILE")
echo "$env_configmap" | kubectl apply -f -

#SECRET FOR POSTGRESS AND JWT
env_secret=$(sed "s/{{JWT_SECRET}}/$JWT_SECRET/g;
s/{{POSTGRESS_USERNAME}}/$DB_USER_NAME/g;
s/{{POSTGRESS_PASSWORD}}/$DB_USER_PASSWORD/g" < "$ENV_SECRET_FILE")
echo "$env_secret" | kubectl apply -f -

#SECRET FOR AWS CREDENTIALS
awsCredentials=$(base64 < ~/.aws/credentials)
awsSecret=$(sed "s/{{AWS_CREDENTIALS}}/$awsCredentials/g" < "$AWS_SECRET_FILE")
echo "$awsSecret" | kubectl apply -f -

kubectl apply -f ./deployment/backend-feed-deployment.yaml
kubectl apply -f ./deployment/backend-user-deployment.yaml
kubectl apply -f ./deployment/reverseproxy-deployment.yaml
kubectl apply -f ./deployment/frontend-deployment.yaml
