.PHONY: build
VERSION ?=release-4.10
# Default image tag

SIDECAR_IMG ?= quay.io/redhat-cne/cloud-event-proxy:$(VERSION)
CONSUMER_IMG ?= quay.io/redhat-cne/cloud-event-consumer:$(VERSION)
UNAME_S := $(shell uname -s)
KUSTOMIZE = $(shell pwd)/bin/kustomize

ifeq ($(UNAME_S),Linux)
	KUSTOMIZE_URL = "https://github.com/kubernetes-sigs/kustomize/releases/download/v1.0.3/kustomize_1.0.3_linux_amd64"	
else
	KUSTOMIZE_URL = "https://github.com/kubernetes-sigs/kustomize/releases/download/v1.0.3/kustomize_1.0.3_darwin_amd64"
endif

kustomize:
@echo "Downloading ${K8S_BIN_DIR}/kustomize for k8s deployments."
	@curl -sSL $(KUSTOMIZE_URL) > ${KUSTOMIZE_BIN}
	@chmod +x ${KUSTOMIZE_BIN}

deploy:kustomize
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE) && $(KUSTOMIZE) edit set image cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl apply -f -

undeploy:kustomize
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE)  && $(KUSTOMIZE) edit set image cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl delete -f -
