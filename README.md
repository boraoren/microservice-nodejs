# Udagram Image Filtering Microservice

1. [Description](#description)
1. [Prerequisites](#prerequisites)
1. [Project Modules](#project-modules)
    1. [Frontend](#frontend)
    1. [Feed Service](#feed-service)
    1. [User Service](#user-service)
1. [Run Project](#run-project)
    1. [Locally](#locally)
    1. [On Aws](#on-aws)
1. [Delete project from AWS](#delete-project-from-aws)

## Prerequisites
The following tools need to be installed
on your local machine

- [Docker](https://www.docker.com/products/docker-desktop)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [KubeOne](https://github.com/kubermatic/kubeone)
- [Terraform](https://www.terraform.io/)
- [Amazon Web Services account](https://console.aws.amazon.com/)
- [DockerHub account](https://hub.docker.com/)

## Description
Udagram is a simple cloud application developed 
alongside the Udacity Cloud Engineering Nanodegree. 
It allows users to register and log into a web client, 
post photos to the feed, and process photos using an 
image filtering microservice.

## Project Modules

The project is split into three parts:

### Frontend
A basic Ionic client web application 
which consumes the RestAPI Backend.
 
### Feed Service

### User Service

## Run Project

clone the repository  
`git clone git@github.com:boraoren/microservice-nodejs.git`

### Locally
1. `touch ~/.profile`
1. add texts below to `~/.profile`
```
POSTGRESS_USERNAME=udagram
POSTGRESS_PASSWORD=password
POSTGRESS_DB=udagram
POSTGRESS_HOST=postgresql
```
1. go to udacity-c3-deployment/docker directory
    1. run `docker-compose up` command

### On Aws
The application is running in a 
Kubernetes Cluster on AWS.

1. AWS S3
    1. Create an AWS/S3 bucket which name is {YOUR_NAME}-udacity-microservice-bucket
    1. give permission
    ```:json
       {
       	"Version": "2012-10-17",
       	"Id": "Policy1565786082197",
       	"Statement": [{
       		"Sid": "Stmt1565786073670",
       		"Effect": "Allow",
       		"Principal": {
       			"AWS": "__YOUR_USER_ARN__"
       		},
       		"Action": [
       			"s3:GetObject",
       			"s3:PutObject"
       		],
       		"Resource": "__YOUR_BUCKET_ARN__/*"
       	}]
       }
   ```
   1. CORS configuration
   ```:xml
        <?xml version="1.0" encoding="UTF-8"?>
         <CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
             <CORSRule>
                 <AllowedOrigin>*</AllowedOrigin>
                 <AllowedMethod>GET</AllowedMethod>
                 <AllowedMethod>POST</AllowedMethod>
                 <AllowedMethod>DELETE</AllowedMethod>
                 <AllowedMethod>PUT</AllowedMethod>
                 <MaxAgeSeconds>3000</MaxAgeSeconds>
                 <AllowedHeader>Authorization</AllowedHeader>
                 <AllowedHeader>Content-Type</AllowedHeader>
             </CORSRule>
        </CORSConfiguration>
    ```

1. Kubernetes Cluster
    1. add texts below to `~/.profile`
    ```:text
       AWS_REGION=${YOUR_AWS_REGION}
       AWS_PROFILE=${YOUR_AWS_PROFILE}
       AWS_BUCKET=${__YOUR_NAME-udacity-microservice-bucket}
       URL=http://localhost:8100
       JWT_SECRET=${YOUR_JWT_SECRET}
    ```
    1. terraform
        1. go to `terraform/aws` directory  
        1. run `terraform init` command
        1. set values
            1. variables.tf line 59
            `default` to your AWS region
            1. variables.tf line 33
            `default` to your SSH public key file path
        1. run `terraform plan` command to confirm
        1. run `terraform apply` command to execute for AWS and enter `yes` 
        after running the command.
        1. run `terraform output -json > tf.json` to create state 
        that will be used by kubeone
    1. kubernetes
        1. go to `terraform/aws` directory
        1. run `kubeone install config.yml --tfjson tf.json` command
        1. set environment for kubeone `KUBECONFIG=$PWD/udagram-kubeconfig`

1. Postgresql Database
    1. Create AWS/RDS/Postgresql instance which name is `udagram`
    1. Terraform step created security group automatically 
    so you should add `udagram_common` security group to your 
    Postgresql database instance to let services access to
    your database.

1. Deploy Application
    1. replace `.profile` file `POSTGRESS_HOST` key  
    with `Endpoint` (you can find endpoint from AWS Web Dashboard RDS Panel 
    Connectivity & Security Tab) 
    1. go to `udacity-c3-deployment/docker` directory
    1. find and replace `borasmus` container image names at below by your own docker hub name; 
        1. backend-user-deployment.yaml
        1. backend-feed-deployment.yaml
        1. frontend-deployment.yaml
        1. reverseproxy-deployment.yaml
        1. docker-compose-build.yaml
        1. docker-compose.yaml
    1. login to your dockerhub `docker login --username=__YOUR_USER_NAME__ --email=__YOUR_EMAIL__`    
    1. build your images `docker-compose -f docker-compose-build.yaml build --parallel`
    1. push your builded images to dockerhub `docker-compose -f docker-compose-build.yaml push`
    1. go to `udacity-c3-deployment/k8s` directory
    1. run `deploy_services.sh` command
    1. run `deploy.sh` command
    1. add CloudWatch agent
        1. go to `udacity-c3-deployment/k8s/fluentd` directory
        1. run `deploy_fluentd.sh`command
    

## Delete Project from AWS
### Delete Kubernetes Cluster
1. go to `terraform/aws` directory
1. run `kubeone reset config.yml` command
1. run `terraform destroy` 
