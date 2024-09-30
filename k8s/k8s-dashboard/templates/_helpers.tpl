{{/*
Expand the name of the chart.
*/}}
{{- define "k8s_dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

