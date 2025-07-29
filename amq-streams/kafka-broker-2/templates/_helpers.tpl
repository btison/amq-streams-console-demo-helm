{{/*
Expand the name of the chart.
*/}}
{{- define "kafka-broker-2.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka-broker-2.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka-broker-2.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kafka-broker-2.labels" -}}
helm.sh/chart: {{ include "kafka-broker-2.chart" . }}
{{ include "kafka-broker-2.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kafka-broker-2.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kafka-broker-2.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kafka-broker-2.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kafka-broker-2.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Find the name of the OpenShift domain
*/}}
{{- define "kafka-broker-2.ocpDomain" -}}
{{- $ingresscontroller := (lookup "operator.openshift.io/v1" "IngressController" "openshift-ingress-operator" "default") | default dict }}
{{- $status := (get $ingresscontroller "status") | default dict }}
{{- $ocpDomain := (get $status "domain") | default dict }}
{{- printf "%s" $ocpDomain }}
{{- end }}

{{/* 
Kafka Bootstrap Server
*/}}
{{- define "kafka-broker-2.bootstrapServer" -}}
{{- if .Values.bootstrapServer }}
{{- .Values.bootstrapServer }}
{{- else if .Values.namespace }}
{{- printf "%s-kafka-bootstrap.%s.svc.cluster.local:9092" (include "kafka-broker-2.name" .) .Values.namespace }}
{{- else }}
{{- printf "%s-kafka-bootstrap.%s.svc.cluster.local:9092" (include "kafka-broker-2.name" .) .Release.Namespace }}
{{- end }}
{{- end }}

{{/* 
Kafka authentication
*/}}
{{- define "kafka-broker-2.authentication" -}}
{{- if eq .Values.authentication.saslMechanism "SCRAM-SHA-512" -}}
authentication:
  type: scram-sha-512
{{- else }}
authentication: {}
{{- end }}
{{- end }}

{{/*
ArgoCD Syncwave
*/}}
{{- define "kafka-broker-2.argocd-syncwave" -}}
{{- if and (.Values.argocd) (.Values.argocd.syncwave) }}
{{- if (.Values.argocd.syncwave.enabled) -}}
argocd.argoproj.io/sync-wave: "{{ .Values.argocd.syncwave.kafka }}"
{{- else }}
{{- "{}" }}
{{- end }}
{{- else }}
{{- "{}" }}
{{- end }}
{{- end }}

{{/*
ArgoCD Syncwave
*/}}
{{- define "kafka-namespace.argocd-syncwave" -}}
{{- if and (.Values.argocd) (.Values.argocd.syncwave) }}
{{- if (.Values.argocd.syncwave.enabled) -}}
argocd.argoproj.io/sync-wave: "{{ .Values.argocd.syncwave.namespace }}"
{{- else }}
{{- "{}" }}
{{- end }}
{{- else }}
{{- "{}" }}
{{- end }}
{{- end }}
