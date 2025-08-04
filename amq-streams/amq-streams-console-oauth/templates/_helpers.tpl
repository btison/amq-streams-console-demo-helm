{{/*
Expand the name of the chart.
*/}}
{{- define "amq-streams-console-oauth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "amq-streams-console-oauth.fullname" -}}
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
{{- define "amq-streams-console-oauth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "amq-streams-console-oauth.labels" -}}
helm.sh/chart: {{ include "amq-streams-console-oauth.chart" . }}
{{ include "amq-streams-console-oauth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "amq-streams-console-oauth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "amq-streams-console-oauth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "amq-streams-console-oauth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "amq-streams-console-oauth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ArgoCD Syncwave
*/}}
{{- define "amq-streams-console-oauth.argocd-syncwave" -}}
{{- if and (.Values.argocd) (.Values.argocd.syncwave) }}
{{- if (.Values.argocd.syncwave.enabled) -}}
argocd.argoproj.io/sync-wave: "{{ .Values.argocd.syncwave.console }}"
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
{{- define "amq-streams-console-oauth-namespace.argocd-syncwave" -}}
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
