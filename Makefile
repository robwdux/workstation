ANSIBLE_VERSION?=2.5.0.0

# REFERENCES
# manual:
#   https://www.gnu.org/software/make/manual/
# style & guide:
#   http://clarkgrubb.com/makefile-style-guide
# help:
#   (simple) https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
#   (advanced) https://www.cmcrossroads.com/article/self-documenting-makefiles

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.SUFFIXES:

# read in os info, accessible to sub-make via export
# man(5) - man 5 os-release
include /etc/os-release
export

.PHONY: all
all: setup install ## setup and install

.PHONY: install
install: ## configure workstation with ansible
	.venv/bin/ansible-playbook ./workstation.yml -v

.PHONY: setup
setup: deps venv ## setup project with python virtualenv
	.venv/bin/pip install ansible==$(ANSIBLE_VERSION)

.PHONY: deps
deps: ## install project setup latest dependencies, fedora
ifeq ($(ID),fedora)
	sudo dnf install -y python2 python-pip
	pip install --user --upgrade pip virtualenv
else
	# https://www.gnu.org/software/make/manual/html_node/Make-Control-Functions.html
	$(error OS not supported... $(ID))
endif

.PHONY: venv
venv: ## instantiate python virtualenv
	virtualenv .venv --no-site-packages

.PHONY: help
help: ## list targets as they appear in this makefile
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

