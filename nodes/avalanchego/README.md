# AvalancheGo
Validator node L1 tracking guide.

## Prerequisites
- AvalancheGo node installed (using Ansible playbook)
- Node P/X/C chain bootstrapped.
- Nginx installed on the node.
- LetsEncrypt installed on the node.

## Step 1. Configure nginx webserver and create SSL certificate

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

- Test RPC call with HTTP endpoint to verify that it works
```sh
$ curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"eth_getChainConfig",
    "params" :[]
}' -H 'content-type:application/json;' http://rpc.your.domain/ext/bc/<blockchainId>/rpc
```

- Create SSL certificates using LetsEncrypt
```sh
$ sudo certbot certonly -d rpc.your.domain --nginx
```

- After SSL certificate is created, note the file path to cert, private key and fullchain, we will need these information to configure nginx and avalanchego node. Typically, these files reside in `/etc/letsencrypt/live/rpc.your.domain` folder. We mostly interest in following files
> - cert.pem
> - privkey.pem
> - fullchain.pem

## Step 2. Enable HTTPS RPC connection on AvalancheGo node

- By default, AvalancheGo node publish RPC HTTP port only, in order to enable HTTPS, appropriate settings are needed to add in `config.json` file
```json
{
  "http-allowed-hosts": "*",
  "http-tls-enabled": true,
  "http-tls-cert-file": "/etc/letsencrypt/live/rpc.your.domain/cert.pem",
  "http-tls-key-file": "/etc/letsencrypt/live/rpc.your.domain/privkey.pem",
}
```

*Note: AvalancheGo node SSL configuration requires `cert.pem` and `privkey.pem`*

- Test the RPC HTTPS connection by curl request
```sh
$ curl -k -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"eth_getChainConfig",
    "params" :[]
}' -H 'content-type:application/json;' https://rpc.your.domain/ext/bc/<blockchainId>/rpc
```

*Note: curl command must include `-k` argument to bypass the https certificate verification*

## Step 3. Enable HTTPS on nginx webserver settings

- Add the proper HTTPS settings in webserver configuration.
```
server {

    # SSL enabled
    listen 443 ssl;
    listen [::]:443 ssl;

    ssl_certificate /etc/letsencrypt/live/rpc-test2.derachain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/rpc-test2.derachain.com/privkey.pem;

    server_name rpc-test2.derachain.com;

    location /  {
        proxy_pass https://localhost:9650;
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

- Create `config.json` file from template, it is neccessary to fulfill **subnetId** and **SSL certificates** to corresponding fields.

- Setup `config.json` file for AvalancheGo
```sh
$ cp config.json ~/.avalanchego/
```

## Troubleshoot

- The RPC public domain MUST be registered on Cloudflare with type A and proxy disabled.

- The validator node firewall MUST allow access to HTTP (80) and HTTPS (443) ports.