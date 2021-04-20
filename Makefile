PROMETHEUS_OPERATOR_VERSION = v0.45.0

helm:
	helm repo add ondrejsika https://helm.oxs.cz
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

crd:
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$(PROMETHEUS_OPERATOR_VERSION)/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

copy-example-values:
	cp values/prom/ingress.example.yml values/prom/ingress.yml
	cp values/prom/alertmanager-config.example.yml values/prom/alertmanager-config.yml

prom:
	kubectl apply -f k8s/ns-prom.yml
	helm upgrade --install \
		prometheus-stack prometheus-community/kube-prometheus-stack \
		-n prometheus-stack \
		-f values/prom/general.yml \
		-f values/prom/ingress.yml \
		-f values/prom/alertmanager-config.yml

prom-uninstall:
	helm uninstall -n prometheus-stack prometheus-stack
