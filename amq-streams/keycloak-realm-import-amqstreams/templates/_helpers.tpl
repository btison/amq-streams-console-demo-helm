{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak-realmimport-amqstreams.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keycloak-realmimport-amqstreams.fullname" -}}
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
{{- define "keycloak-realmimport-amqstreams.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keycloak-realmimport-amqstreams.labels" -}}
helm.sh/chart: {{ include "keycloak-realmimport-amqstreams.chart" . }}
{{ include "keycloak-realmimport-amqstreams.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keycloak-realmimport-amqstreams.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keycloak-realmimport-amqstreams.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "keycloak-realmimport-amqstreams.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "keycloak-realmimport-amqstreams.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ArgoCD Syncwave
*/}}
{{- define "keycloak-realmimport-amqstreams.argocd-syncwave" -}}
{{- if .Values.argocd }}
{{- if and (.Values.argocd.syncwave) (.Values.argocd.enabled) -}}
argocd.argoproj.io/sync-wave: "{{ .Values.argocd.syncwave }}"
{{- else }}
{{- "{}" }}
{{- end }}
{{- else }}
{{- "{}" }}
{{- end }}
{{- end }}

{{/*
Amqstreams client secret
*/}}
{{- define "keycloak-realmimport-amqstreams.client-amqstreams-secret" -}}
{{- if .Values.client.amqstreams.secret }}
{{- .Values.client.amqstreams.secret }}
{{- else }}
{{- randAlphaNum 32 }}
{{- end }}
{{- end }}

{{/*
User password
*/}}
{{- define "keycloak.user.password" -}}
{{- if .Values.users.password }}
{{- .Values.users.password }}
{{- else }}
{{- randAlpha 8 }}
{{- end }}
{{- end }}
