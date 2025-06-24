# Ansible Inventory généré automatiquement par Terraform
# Ne pas modifier manuellement - sera écrasé à chaque déploiement

[all:vars]
ansible_ssh_private_key_file=${ssh_private_key_path}
ansible_user=root
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

%{ for name, ip in vm_ips ~}
%{ if contains(split("-", name), "pdns") ~}
[pdns]
${name} ansible_host=${ip}

%{ endif ~}
%{ if contains(split("-", name), "ldap") ~}
[ldap]  
${name} ansible_host=${ip}

%{ endif ~}
%{ if contains(split("-", name), "mariadb") ~}
[mariadb_cluster]
${name} ansible_host=${ip}

%{ endif ~}
%{ if contains(split("-", name), "moodle") ~}
[moodle]
${name} ansible_host=${ip}

%{ endif ~}
%{ endfor ~}

[all]
%{ for name, ip in vm_ips ~}
${name} ansible_host=${ip}
%{ endfor ~}
