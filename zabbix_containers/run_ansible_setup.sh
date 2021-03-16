#!/bin/bash
apt update
apt -y upgrade
apt -y install host netcat nmap mlocate vim sshpass
apt -y install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt -y install ansible
sed -i "/^#forks/ cforks          = 50" /etc/ansible/ansible.cfg
sed -i '/host_key_checking/s/^#//g' /etc/ansible/ansible.cfg
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N "" <<< n
echo -e "\n\n\nANSIBLE PUBLIC KEY (ADD IT TO AUTHORIZED KEYS):\n"
cat ~/.ssh/id_rsa.pub