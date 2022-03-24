.PHONY: build
VERSION ?=v4.9
# Default image tag

SIDECAR_IMG ?= quay.io/redhat-cne/cloud-event-proxy:$(VERSION)
CONSUMER_IMG ?= quay.io/redhat-cne/cloud-event-consumer:$(VERSION)

kustomize:
ifeq (, $(shell which kustomize))
		@{ \
		set -e ;\
		KUSTOMIZE_GEN_TMP_DIR=$$(mktemp -d) ;\
		cd $$KUSTOMIZE_GEN_TMP_DIR ;\
		go mod init tmp ;\
		go get sigs.k8s.io/kustomize/kustomize/v3@v3.5.4 ;\
		rm -rf $$KUSTOMIZE_GEN_TMP_DIR ;\
		}
KUSTOMIZE=$(GOBIN)/kustomize
else
KUSTOMIZE=$(shell which kustomize)
endif

deploy:kustomize
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE) && $(KUSTOMIZE) edit set image  cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl apply -f -

undeploy:kustomize
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE)  && $(KUSTOMIZE) edit set image  cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl delete -f -