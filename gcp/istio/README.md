# Istio service mesh
The installation guide for Istio service mesh

## Prerequisites
- Ready [GKE cluster](../gke/README.md)

## Setup
- Install Istio with `default` profile
```sh
$ istioctl install --set profile=default -y
```

- Install ingress gateway similarly to [AWS](../istio/README.md)

- Provision a static IP for Ingress gateway
```sh
$ gcloud compute addresses create gw-static-ip --region <gcp-region>
```

*Note: the `gcp-region` by default is `us-central1`*

- Bind the static IP to the Ingress gateway
```sh
$ kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec": {"loadBalancerIP": "<STATIC_IP>"}}'
```
