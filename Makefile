.DEFAULT_GOAL:=help

.EXPORT_ALL_VARIABLES:

ifndef VERBOSE
.SILENT:
endif

# set default shell
SHELL=/usr/bin/env bash -o pipefail -o errexit

TAG ?= $(shell cat TAG)
POETRY_HOME ?= ${HOME}/.local/share/pypoetry
POETRY_BINARY ?= ${POETRY_HOME}/venv/bin/poetry
POETRY_VERSION ?= 1.2.0

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: show-version
show-version:  ## Display version
	echo -n "${TAG}"

.PHONY: build
build: ## Build fastapi-mvc-usecase package
	echo "[build] Build fastapi-mvc-usecase package."
	${POETRY_BINARY} build

.PHONY: install
install:  ## Install fastapi-mvc-usecase with poetry
	@build/install.sh

.PHONY: image
image:  ## Build fastapi-mvc-usecase image
	@build/image.sh

.PHONY: metrics
metrics: install ## Run fastapi-mvc-usecase metrics checks
	echo "[metrics] Run fastapi-mvc-usecase PEP 8 checks."
	${POETRY_BINARY} run flake8 --select=E,W,I --max-line-length 80 --import-order-style pep8 --statistics --count fastapi_mvc_usecase
	echo "[metrics] Run fastapi-mvc-usecase PEP 257 checks."
	${POETRY_BINARY} run flake8 --select=D --ignore D301 --statistics --count fastapi_mvc_usecase
	echo "[metrics] Run fastapi-mvc-usecase pyflakes checks."
	${POETRY_BINARY} run flake8 --select=F --statistics --count fastapi_mvc_usecase
	echo "[metrics] Run fastapi-mvc-usecase code complexity checks."
	${POETRY_BINARY} run flake8 --select=C901 --statistics --count fastapi_mvc_usecase
	echo "[metrics] Run fastapi-mvc-usecase open TODO checks."
	${POETRY_BINARY} run flake8 --select=T --statistics --count fastapi_mvc_usecase tests
	echo "[metrics] Run fastapi-mvc-usecase black checks."
	${POETRY_BINARY} run black -l 80 --check fastapi_mvc_usecase

.PHONY: unit-test
unit-test: install ## Run fastapi-mvc-usecase unit tests
	echo "[unit-test] Run fastapi-mvc-usecase unit tests."
	${POETRY_BINARY} run pytest tests/unit

.PHONY: integration-test
integration-test: install ## Run fastapi-mvc-usecase integration tests
	echo "[unit-test] Run fastapi-mvc-usecase integration tests."
	${POETRY_BINARY} run pytest tests/integration

.PHONY: coverage
coverage: install  ## Run fastapi-mvc-usecase tests coverage
	echo "[coverage] Run fastapi-mvc-usecase tests coverage."
	${POETRY_BINARY} run pytest --cov=fastapi_mvc_usecase --cov-fail-under=90 --cov-report=xml --cov-report=term-missing tests

.PHONY: test
test: unit-test integration-test  ## Run fastapi-mvc-usecase tests

.PHONY: docs
docs: install ## Build fastapi-mvc-usecase documentation
	echo "[docs] Build fastapi-mvc-usecase documentation."
	${POETRY_BINARY} run sphinx-build docs site

.PHONY: dev-env
dev-env: image ## Start a local Kubernetes cluster using minikube and deploy application
	@build/dev-env.sh

.PHONY: clean
clean: ## Remove .cache directory and cached minikube
	minikube delete && rm -rf ~/.cache ~/.minikube
