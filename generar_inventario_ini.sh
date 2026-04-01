#!/bin/bash
echo "[springboot]" > inventory.ini
terraform output -json ip_de_spring | jq -r '.[]' >> inventory.ini
echo "[springboot:vars]" >> inventory.ini
echo "ansible_user=ubuntu" >> inventory.ini
echo "ansible_ssh_private_key_file=/home/rusok/Descargas/ParaAnsible.pem" >> inventory.ini
