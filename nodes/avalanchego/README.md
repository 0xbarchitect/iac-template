# AvalancheGo
Validator node L1 tracking guide.

## Prerequisites
- AvalancheGo node installed (using Ansible playbook)
- Node P/X/C chain bootstrapped.
- Nginx installed on the node.
- LetsEncrypt installed on the node.

## Setup
- Config RPC public using nginx, in the first step, RPC public will use HTTP port, which is replaced by HTTPS later on.
```
server {
    listen 80;
    listen [::]:80;

    server_name rpc.your.domain;

    location /  {
        proxy_pass http://localhost:9650;
	      add_header 'Access-Control-Allow-Origin' '*' always;
	      proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	      proxy_ssl_verify off;
    }

    access_log /var/log/nginx/rpc_access.log;
    error_log /var/log/nginx/rpc_error.log;
}
```


- Create SSL cerificates using LetsEncrypt

- Create `config.json` file from template, it is neccessary to fulfill **subnetId** and **SSL certificates** to corresponding fields.

- Setup `config.json` file for AvalancheGo
```sh
$ cp config.json ~/.avalanchego/
```

- 