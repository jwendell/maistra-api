
# Produce CRDs that work back to Kubernetes 1.11 (no version conversion)
CRD_OPTIONS ?= "crd:trivialVersions=true,preserveUnknownFields=false,crdVersions=v1beta1"

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

all: build
build: generate-client generate-lister generate-informer generate-copy generate-crd

generate-crd: controller-gen
	$(CONTROLLER_GEN) $(CRD_OPTIONS) paths=./... output:dir=./manifests/
	sed -i -e '/---/d' ./manifests/maistra.io_*.yaml

generate-copy: controller-gen ## Generate code containing DeepCopy, DeepCopyInto, and DeepCopyObject method implementations.
	$(CONTROLLER_GEN) object:headerFile="header.go.txt" paths="./..."

kube_base_output_package = maistra.io/api
kube_clientset_package = $(kube_base_output_package)/client
kube_listers_package = $(kube_base_output_package)/client/listers
kube_informers_package = $(kube_base_output_package)/client/informers

empty :=
space := $(empty) $(empty)

kube_api_packages = $(subst $(space),$(empty), \
	$(kube_base_output_package)/controlplane/v1, \
	$(kube_base_output_package)/controlplane/v2, \
	$(kube_base_output_package)/extension/v1, \
	$(kube_base_output_package)/extension/v1alpha1, \
	$(kube_base_output_package)/federation/v1alpha1, \
	$(kube_base_output_package)/member/v1, \
	$(kube_base_output_package)/memberroll/v1 \
	)

generate-client: client-gen
	$(CLIENT_GEN) --clientset-name versioned --input-base "" --input $(kube_api_packages) --output-package $(kube_clientset_package) -h header.go.txt

generate-lister: lister-gen
	$(LISTER_GEN) --input-dirs $(kube_api_packages) --output-package $(kube_listers_package) -h header.go.txt

generate-informer: informer-gen
	$(INFORMER_GEN) --input-dirs $(kube_api_packages) --versioned-clientset-package $(kube_clientset_package)/versioned --listers-package $(kube_listers_package) --output-package $(kube_informers_package) -h header.go.txt --single-directory

CONTROLLER_GEN = $(shell pwd)/bin/controller-gen
controller-gen: ## Download controller-gen locally if necessary.
	$(call go-get-tool,$(CONTROLLER_GEN),sigs.k8s.io/controller-tools/cmd/controller-gen@v0.4.1)

LISTER_GEN = $(shell pwd)/bin/lister-gen
lister-gen: ## Download lister-gen locally if necessary.
	$(call go-get-tool,$(LISTER_GEN),k8s.io/code-generator/cmd/lister-gen@v0.20.6)

INFORMER_GEN = $(shell pwd)/bin/informer-gen
informer-gen: ## Download informer-gen locally if necessary.
	$(call go-get-tool,$(INFORMER_GEN),k8s.io/code-generator/cmd/informer-gen@v0.20.6)

CLIENT_GEN = $(shell pwd)/bin/client-gen
client-gen: ## Download client-gen locally if necessary.
	$(call go-get-tool,$(CLIENT_GEN),k8s.io/code-generator/cmd/client-gen@v0.20.6)

# go-get-tool will 'go get' any package $2 and install it to $1.
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-get-tool
@[ -f $(1) ] || { \
set -e ;\
TMP_DIR=$$(mktemp -d) ;\
cd $$TMP_DIR ;\
go mod init tmp ;\
echo "Downloading $(2)" ;\
GOBIN=$(PROJECT_DIR)/bin go get $(2) ;\
rm -rf $$TMP_DIR ;\
}
endef
