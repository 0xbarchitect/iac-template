{{/*
Virtual Service definition
*/}}
{{- define "virtual.service" }}
{{- $serviceName := .name -}}
{{- $servicePort := .port -}}
{{- $virtualServiceName := .virtualName -}}
{{- $prefixes := .prefixes -}}
{{- range .namespaces }}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ $virtualServiceName }}
  namespace: {{ .name }}
spec:
  hosts:
    {{- range .hosts }}
    - {{ . }}
    {{- end }}
  gateways:
    - istio-system/gateway-http
    - mesh
  http:
    - route:
        - destination:
            host: {{ $serviceName }}
            port:
              number: {{ $servicePort }}
      match:
        {{- range $prefixes }}
        - uri:
            prefix: {{ . }}
        {{- end }}
---
{{- end }}
{{- end }}

