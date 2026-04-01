#!/bin/bash
# Inventario dinámico en formato JSON válido para Ansible

# Obtenemos las IP's desde Terraform

IPS=$(terraform output -json ip_de_spring | jq -r '.[]')

# Iniciando el inventario JSON
echo '{'
echo '  "springboot": {'
echo '    "hosts": ['
PRIMERO=1
for ip in $IPS; do
  if [ $PRIMERO -eq 1 ]; then
    echo '"$ip"'
    PRIMERO=0
  else
    echo ',$ip'
  fi
done
echo '    ],'
echo '    "vars": {'
echo '      "ansible_user": "ubuntu",'
echo '      "ansible_ssh_private_key_file": "/home/rusok/Descargas/ParaAnsible.pem"'
echo '    }'
echo '  }'
echo '}'
