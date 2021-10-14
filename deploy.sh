#!/usr/bin/env bash

# terminal colours
blue=`tput setaf 4`
green=`tput setaf 2`
reset=`tput sgr0`

echoMessage() {
  echo  -e "${1}========================= ${2} ============================== ${reset} \n "
}

# Deploy infra
deploy-infra() {
  echoMessage "${blue}" "deploying cluster using Terraform"
  cd infra/terraform
  terraform apply -auto-approve 
  echoMessage "${green}" "cluster deployed successfully"
}

# Expose application service
update-kubeconfig(){
  aws eks --region us-west-1 update-kubeconfig --name on-cluster
}

# Deploy argocd stack 
deploy-argocd() {
 kubectl create namespace argocd
 echoMessage "${blue}" "Deploying Argocd"
 kubectl apply -f infra/argocd/install-argocd.yaml -n argocd
 echoMessage "${green}" "Argocd deployed successfully"
}


# Expose argocd service 
expose-argocd(){
  kubectl port-forward svc/argocd-server -n argocd 8080:80
}

# Retrieve Argocd password
get-argocd-password(){
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -D
}

deploy-argocd-app() {
 echoMessage "${blue}" "Deploying Argocd"
 kubectl apply -f infra/argocd/app.yaml
 echoMessage "${green}" "Argocd deployed successfully"
}

# Expose go-httpbin service 
expose-app(){
  kubectl port-forward svc/go-httpbin -n go-httpbin  8081:80  
}

delete-argocd() {
 kubectl delete -f infra/argocd/app.yaml
 kubectl delete -f infra/argocd/install-argocd.yaml 
 kubectl delete ns argocd
 kubectl delete ns go-httpbin 
}

# Delete vpc and k8s cluster
delete-infra(){
echoMessage "${blue}" "deleting infra"
cd infra/terraform
terraform destroy -auto-approve 
echoMessage "${green}" "infrastructure deleted successfully"

}

main() {
  deploy-infra
  update-kubeconfig
  deploy-argocd
  get-argocd-password
  deploy-argocd-app
  expose-app
  delete-argocd
  delete-infra
}

$@