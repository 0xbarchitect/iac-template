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

- It is recommended to dryrun a playbook before applying to the live hosts
```sh
$ ansible-playbook archivenode.yml -i <inventory_file> --tags "testnet" --check
```

*Note: replace tags with `testnet` or `mainnet` respectively*

- Apply playbook to hosts
```sh
$ ansible-playbook archivenode.yml -i <inventory_file> --tags "testnet"
```

*Note: replace tags with `testnet` or `mainnet` respectively*


## Troubleshoot

- Some commands for debuging and investigation
```sh
$ ansible all --list-hosts -i hosts
$ ansible all -m ping -i hosts
$ ansible all -m setup -i hosts
```

## Cleanup

- Delete blockchain DB
```sh
$ sudo su root
$ cd ~/.avalanchego; rm -rf ./*
```
