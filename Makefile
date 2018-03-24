ANSIBLE_VERSION=2.5.0.0

# REFERENCES
# manual:
#   https://www.gnu.org/software/make/manual/
# style: 
#   http://clarkgrubb.com/makefile-style-guide
# help:
#   (simple) https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
#   (advanced) https://www.cmcrossroads.com/article/self-documenting-makefiles

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: all
all: setup install

.PHONY: all
install:
	

.PHONY: setup
setup: deps venv ## setup project with python virtualenv
	.venv/bin/pip install ansible==$(ANSIBLE_VERSION)

.PHONY: deps
deps: ## install project setup latest dependencies, fedora
	sudo dnf install -y python2 python-pip
	pip install --user --upgrade pip virtualenv

.PHONY: venv
venv: ## instantiate python virtualenv
	virtualenv .venv --no-site-packages

.PHONY: help
help: ## list targets as they appear in this makefile
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
