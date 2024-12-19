# AvalancheGo
Validator node L1 installation guide.

## Prerequisites
- AvalancheGo node installed (using Ansible playbook)
- Node P/X/C chain bootstrapped.
- Nginx installed on the node.
- LetsEncrypt installed on the node.

## Step 1. Configure AvalancheGo to track L1

- Copy SubnetEVM plugin to `plugins` folder of the working directory. By default, the working dir is `/root/.avalanchego`. The SubnetEVM plugin can be found in the avalanche-cli L1 folder after L1 creation.

- Create `chainConfigs/blockchainId` folder and copy `chainConfigs/config.json` file to the new created folder. You MUST replace `blockchainId` with the real value of L1, e.g. `yMz6EoVVaYVUJDozWNtvvHddutUwK7Tfqd2z7nXoG7zydyHEJ`

- Create main `config.json` file from template. You MUST replace `subnetId` with the real value of L1, e.g. `cYtFtRBJ9QUJwv6RbVx4DMSWEu2bLQ1b4HPtk3MhMfCHo3Y4V`
```json
{
  "chain-config-dir": "/root/.avalanchego/chainConfigs",
  "http-allowed-hosts": "*",
  "track-subnets": "subnetId"
}
```

- Update the execution command of AvalancheGo node
```sh
$ avalanchego --config-file /root/.avalanchego/config.json --network-id=fuji
```

*Note: the systemd script is needed to update correspondingly*

- Test the tracking status by curl command
```sh
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"2JJ83KgSociZyRjVyKQP7WE14Sow6WaoNiZLtMuefV8CnfwCgG"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

## Step 2. Configure nginx webserver and create SSL certificate

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

*Note: replace `rpc.your.domain` with your real domain*

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

## Step 3. Enable HTTPS RPC connection on AvalancheGo node

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

- Test the local RPC HTTPS connection by curl request
```sh
$ curl -k -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"eth_getChainConfig",
    "params" :[]
}' -H 'content-type:application/json;' https://127.0.0.1:9650/ext/bc/<blockchainId>/rpc
```

*Note: curl command must execute with `-k` argument to bypass the https certificate verification*

## Step 4. Enable HTTPS on nginx webserver settings

- Add the proper HTTPS settings in webserver configuration.
```
server {

    # SSL enabled
    listen 443 ssl;
    listen [::]:443 ssl;

    ssl_certificate /etc/letsencrypt/live/rpc.your.domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/rpc.your.domain/privkey.pem;

    server_name rpc.your.domain;

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

*Note: the webserver config file uses the LetsEncrypt `fullchain.pem` file instead of `cert.pem`*

- Test the RPC HTTPS public connection by curl request
```sh
$ curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"eth_getChainConfig",
    "params" :[]
}' -H 'content-type:application/json;' https://rpc.your.domain/ext/bc/<blockchainId>/rpc
```

## Troubleshoot

- The RPC public domain MUST be registered on Cloudflare with type A and proxy disabled.

- The validator node firewall MUST allow access to HTTP (80) and HTTPS (443) ports.