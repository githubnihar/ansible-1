# Zabbix 5.2 Upgrade

Technical Plan for Zabbix 5.2 upgrade using Ansible playbooks and Docker containers

#### Ubuntu on Azure Cloud

Ubuntu Server 20.04 LTS (Canonical) is the planned host for the containers,
 and will be deployed on Azure Cloud.
* [Endorsed by Microsoft on Azure] (https://docs.microsoft.com/en-us/azure/virtual-machines/linux/endorsed-distros#supported-distributions-and-versions)
* [Ubuntu on Azure] (https://ubuntu.com/azure)

#### Docker Containers

Docker will be setup on Ubuntu host server as a SNAP application (container) to avoid any dependency issue with host packages/libraries.
It includes needed docker-composer.


#### Ansible Container

Official Ubuntu container will be used to setup an Ansible Server:
* [ubuntu/apache2] (https://hub.docker.com/r/ubuntu/apache2)
<br/>for more information: [Ubuntu LTS Docker Images] (https://ubuntu.com/security/docker-images)


#### Zabbix Containers

Official Zabbix containers will be used for deploy:
* [Official Zabbix Dockerfiles] (https://github.com/zabbix/zabbix-docker)
<br/>for more information: (https://www.zabbix.com/container_images)



<br/>
# Technical Plan
***Note: TO BE UPDATED IN TERMS OF APPLICATION, DATABASE AND SCRIPTS MIGRATIONS***

#### 1. Deploy Azure Virtual Machine on Azure

Ubuntu Server 20.04 LTS (CANONICAL GROUP LTD)
NOTE: SGL configurations to be deployed (AD sync, DNS, NTP, networking, etc)


#### 2. Install Docker in Ubuntu Server (host), via SNAP

> 2.1. Upgrade Ubuntu OS: <br/>
> `# apt update` <br/>
> `# apt -y upgrade`<br/>

> 2.2. Install Docker via SNAP: <br/>
> `# snap install docker`<br/>

> 2.3. Install additional tools: <br/>
`# apt -y install host netcat nmap mlocate vim` <br/>


#### 3. Setup Ansible docker container

Ansible account and playbooks location should be setup as it is on actual onsite Ansible Server.<br/>
Both hosts and zabbix_containers.yml should be present in host server filesystem `/home/ansible/playbooks/`.<br/>

> 3.1. Pull Ubuntu docker container from Docker Hub: <br/> 
> `# docker pull ubuntu/apache2` <br/>

>  3.2. Start Ubuntu docker container, and present host directory /home/ansible/playbooks/ as a volume to container, for playbook usage: <br/> 
> `# docker run -d --name ubuntu_ansible -e TZ=UTC -v /root/playbooks:/root/playbooks ubuntu/apache2` <br/>

> 3.3. Copy and Run Ansible setup script inside the container: <br/> 
> `# docker cp /root/run_ansible_setup.sh ubuntu_ansible:/root/` <br/>
> `# docker exec -it ubuntu_ansible /bin/bash /root/run_ansible_setup.sh` <br/>

Note: Setup SSH Key on root user inside Ansible container to be able to run playbooks on target hosts with root privileges. <br/> 


#### 4. Ansible Playbook to setup Zabbix 5.2

***Note: TO BE UPDATED YAML FILE USED BY DOCKER-COMPOSER, which has Zabbix parameters for architecture being deployed.*** <br/>
Target host will be the Ubuntu Server (host), where ansible will invoke docker-compose to create Zabbix containers as per YAML configuration. <br/>

> 4.1. Run Ansible Playbook: <br/> 
> `# docker exec -it ubuntu_ansible ansible-playbook -i /root/playbooks/hosts /root/playbooks/zabbix_setup.yml` <br/>

> 4.2. Review Zabbix docker containers: <br/> 
> `# docker ps` <br/>

> 4.3. Access Zabbix Web Interface for review. <br/> 




