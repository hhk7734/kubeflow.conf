REGISTRY ?= docker.io
BASE_REPOSITORY ?= base
CODE_SERVER_REPOSITORY ?= code-server
JUPYTER_REPOSITORY ?= jupyter
TAG ?= $(shell git describe --tags --always --dirty)

BUILDER := $(shell [ -n "$$(command -v buildah 2>/dev/null)" ] && echo "buildah bud --format docker" || echo "docker build")

.PHONY: all
all: base code-server-only jupyter-only

.PHONY: base
base:
	$(BUILDER) ${BUILD_ARG} -t ${REGISTRY}/${BASE_REPOSITORY}:${TAG} -f base/Dockerfile base

.PHONY: code-server-only
code-server-only:
	$(BUILDER) ${BUILD_ARG} --build-arg BASE_IMG=${REGISTRY}/${BASE_REPOSITORY}:${TAG} \
		-t ${REGISTRY}/${CODE_SERVER_REPOSITORY}:${TAG} -f code-server/Dockerfile code-server

.PHONY: code-server
code-server: base code-server-only

.PHONY: jupyter-only
jupyter-only:
	$(BUILDER) ${BUILD_ARG} --build-arg BASE_IMG=${REGISTRY}/${BASE_REPOSITORY}:${TAG} \
		-t ${REGISTRY}/${JUPYTER_REPOSITORY}:${TAG} -f jupyter/Dockerfile jupyter

.PHONY: jupyter
jupyter: base jupyter-only