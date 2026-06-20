#!/bin/bash

cd ../terraform
# terraform apply -auto-approve

ACR_USER=$(terraform output -raw acr_admin_username)
ACR_PASSWORD=$(terraform output -raw acr_admin_password)

cd ../ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts playbook.yml \
  --extra-vars "acr_user=$ACR_USER acr_password=$ACR_PASSWORD"

# Solo VM
# ansible-playbook -i hosts playbook.yml --limit vm \
#   --extra-vars "acr_user=$ACR_USER acr_password=$ACR_PASSWORD"

# # Solo Kubernetes
# ansible-playbook -i hosts playbook.yml --limit k8s \
#   --extra-vars "acr_user=$ACR_USER acr_password=$ACR_PASSWORD"