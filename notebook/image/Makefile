BUILDER := $(shell [ -n "$$(command -v buildah 2>/dev/null)" ] && echo "buildah bud --format docker" || echo "docker build")

.PHONY: base
base:
	$(BUILDER) ${BASE_BUILD_ARG} -t base -f base/Dockerfile base

.PHONY: code-server-only
code-server-only:
	$(BUILDER) -t code-server -f code-server/Dockerfile code-server

.PHONY: code-server
code-server: base code-server-only
