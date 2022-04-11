.PHONY: build
VERSION ?=4.10
# Default image tag

SIDECAR_IMG ?= quay.io/redhat-cne/cloud-event-proxy:$(VERSION)
CONSUMER_IMG ?= quay.io/redhat-cne/cloud-event-consumer:release-$(VERSION)

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

# Download kustomize locally if necessary, preferring the $(pwd)/bin path over global if both exist.
.PHONY: kustomize
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
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE) && $(KUSTOMIZE) edit set image cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl apply -f -

undeploy:kustomize
	cd ./manifests && $(KUSTOMIZE) edit set image cloud-event-sidecar=${SIDECAR_IMG} && $(KUSTOMIZE)  && $(KUSTOMIZE) edit set image cloud-event-consumer=${CONSUMER_IMG}
	$(KUSTOMIZE) build ./manifests | kubectl delete -f -
