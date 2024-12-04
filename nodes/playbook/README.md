# Nodes playbook
The Ansible playbook for nodes validators.

## Prerequisites
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu)

## Setup
- Create inventory file `hosts` from template and populate all necessary secrets.
```sh
$ cp hosts.example hosts
```

## Run
- Apply playbook
```sh
$ ansible-playbook -i hosts archivenode.yml
```

## Troubleshoot
- Some commands for debuging and investigation
```sh
$ ansible all -m --list-hosts -i hosts
$ ansible all -m ping -i hosts
$ ansible all -m setup -i hosts
```

## Cleanup
- Delete blockchain DB
```sh
$ sudo su root
$ cd ~/.avalanchego; rm -rf ./*
```
