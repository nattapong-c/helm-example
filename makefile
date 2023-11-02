ext := ""
ifeq ($(OS),Windows_NT)
	ext = ".exe"
endif

helm-repo:
	helm repo add stakater https://stakater.github.io/stakater-charts
	helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo
	helm repo add external-secrets https://charts.external-secrets.io
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add kedacore https://kedacore.github.io/charts

helm-update:
	helm repo update

helm-resource-argo:
	helm upgrade --install argo-cd azure-marketplace/argo-cd \
		--namespace argo-system \
		--create-namespace \
		--wait

helm-resource-external-secrets:
	helm upgrade --install external-secrets external-secrets/external-secrets \
		--set "installCRDs=true" \
		--namespace external-secrets \
		--create-namespace \
		--wait

helm-resource-keycloak:
	helm upgrade --install keycloak bitnami/keycloak \
		--set "auth.adminUser=user" \
		--set "auth.adminPassword=password" \
		--set "service.type=ClusterIP" \
		--namespace keycloak-system \
		--create-namespace \
		--wait

helm-resource-redis:
	helm upgrade --install redis bitnami/redis \
		--set "auth.enabled=false" \
		--namespace redis-system \
		--create-namespace \
		--wait

helm-resource-loki:
	helm upgrade --install loki grafana/loki \
		-f loki/${stage}.yml \
		--version 5.5.0 \
		--namespace monitoring \
		--create-namespace \
		--wait

helm-resource-promtail:
	helm upgrade --install promtail grafana/promtail \
		-f promtail/${stage}.yml \
		--version 6.11.1 \
		--namespace monitoring \
		--create-namespace \
		--wait

helm-resource-grafana:
	helm upgrade --install grafana grafana/grafana \
		-f grafana/${stage}.yml \
		--version 6.56.2 \
		--namespace monitoring \
		--create-namespace \
		--wait

helm-resource-minio:
	helm upgrade --install minio azure-marketplace/minio \
		-f minio/minio.yml \
		--version 11.10.16 \
		--namespace monitoring \
		--create-namespace \
		--wait

helm-resource-prometheus:
	helm upgrade --install prometheus prometheus-community/prometheus \
		-f prometheus/${stage}.yml \
		--version 22.4.1 \
		--namespace monitoring \
		--create-namespace \
		--wait

helm-resource-keda:
	helm upgrade --install keda kedacore/keda \
		--namespace keda \
		--create-namespace \
		--wait

helm-resource-traefik:
	helm upgrade --install traefik traefik/traefik \
		-f traefik/traefik.yml \
		--namespace traefik \
		--wait

helm-resource-rabbitmq:
	helm upgrade --install rabbitmq oci://registry-1.docker.io/bitnamicharts/rabbitmq \
		-f rabbitmq/${stage}.yml \
		--namespace rabbitmq-system \
		--create-namespace \
		--wait
