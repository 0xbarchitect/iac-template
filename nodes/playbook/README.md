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

- It is recommended to dryrun a playbook before applying to the live hosts, i.e.
```sh
$ ansible-playbook avalanchego.yml -i <hosts_file> --tags "testnet" --check
```

*Note: replace tags with `testnet` or `mainnet` respectively*

- After dryrunning, install the packages by following order

> 1.  Install AvalancheGo by applying the playbook to hosts
```sh
$ ansible-playbook avalanchego.yml -i <hosts_file> --tags "testnet"
```

*Note: replace tags with `testnet` or `mainnet` respectively*

> 2. Install Avalanche CLI
```sh
$ ansible-playbook avalanchecli.yml -i <hosts_file>
```

> 3. Install Nginx
```sh
$ ansible-playbook nginx.yml -i <hosts_file>
```

> 4. Install LetsEncrypt (for https)
```sh
$ ansible-playbook letsencrypt.yml -i <hosts_file>
```

## Troubleshoot

- Some commands for debuging and investigation
```sh
$ ansible all --list-hosts -i <hosts_file>
$ ansible all -m ping -i <hosts_file>
$ ansible all -m setup -i <hosts_file>
```

## Cleanup

- Delete blockchain DB
```sh
$ sudo su root
$ cd ~/.avalanchego; rm -rf ./*
```
