
  

  

# Go-httpbin App

This is the link to my documentation [Google docs link](https://docs.google.com/document/d/1A7WEx7mT9K3UoXUQl7TDt9BJ3FxbFr4xfwFZWdNGbec/edit?usp=sharing)


## Watch Demo Video

[![Alt text](https://img.youtube.com/vi/fCHhccAY-9w/0.jpg)](https://www.youtube.com/watch?v=fCHhccAY-9w)

# Requirements

  
  

- Install [Terraform v0.15.0](https://learn.hashicorp.com/tutorials/terraform/install-cli)

  

- Install [Kubectl](https://kubernetes.io/docs/tasks/tools/)

## Deployment

  

1. Clone the repository

  

2. cd into the repository

  

> cd go-httpbin/

  

The default Terraform values are in `infra/terraform/variable.tf .` By default the script deploys the infrastructure in `us-west-1` you can change this in this file

  

<br>

  
  

### Deployment Infrastructure

  

1. Run the command below to deploy the vpc and the kubernetes cluster . Ensure you have configured your AWS credentials

  

  

```bash

 ./deploy.sh deploy-infra

```

  

  

2. To update your kubeconfig file run

```bash

./deploy.sh update-kubeconfig

```

  

  

## Deploy ArgoCD

 
1. Run the command below to deploy ArgoCD server on the kubernetes cluster that was deployed in the step 1

  

  

```bash

./deploy.sh deploy-argocd

```

  

  

2. After ensuring that the ArgoCD pods are runining, run the command below to deploy ArgoCD application.


```bash

./deploy.sh deploy-argocd-app

```


If you clone this repository into your own account update the repoUrl section in the `infra/argocd/app.yaml `

 ```
source:
repoURL: https://github.com/ekpangmichael/go-httpbin.git
targetRevision: argocd
path: deployment/charts
```

  

3. Run the command below to get the default ArgoCD password

```
./deploy.sh get-argocd-password 
``` 
  

4. Expose ArgoCD Service 
```
./deploy.sh expose-argocd   
```
The command will expose ArgoCD service on port 8080, use the password you got from step 2 and username `admin` to login to ArgoCD GUI.
  
When you login you will noticed that ArgoCD has deployed the application automatically, ArgoCD is constantly watching the deployment directory for new changes in the helm chart and  this will trigger a new deployment 



## Delete the Infrastructure

  

To delete all infrastructure run

```bash

./deploy.sh delete-infra 

```
  

#### CI/CD pipeline

  I'm using Github Actions for the CI/CD pipeline, the workflow files can be found in `.github/workflows`. directory 

The following happens when you merged a PR to main branch
- The workflow run the test, lint and build job
- The workflow builds the docker image and upload to Dockerhub
- Create and release and update the helm chart with the new image tag
- ArgoCD detects the changes in the helm directory and triggers a deployment

  

## Major Technologies  

ArgoCD Visit [here](https://expressjs.com) for details.

Terraform: Visit [here](https://www.postgresql.org/docs) for details.

Kubernetest: Visit [here](https://sequelize.org/master) for details.

Helm: Visit [Helm](https://helm.sh/) for details

