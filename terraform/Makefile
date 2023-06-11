SHELL := /bin/bash
PWD := $(shell pwd)
DOCKER_IMAGE := hashicorp/terraform:light
-include .env
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

.PHONY: init plan apply destroy console

init:
	docker run -it --rm \
		-v $(PWD):/app/ \
		-w /app/ \
		$(DOCKER_IMAGE) init

plan:
	docker run -it --rm \
		-v $(PWD):/app/ \
		-w /app/ \
		--env AWS_ACCESS_KEY_ID \
		--env AWS_SECRET_ACCESS_KEY \
		$(DOCKER_IMAGE) plan

apply:
	docker run -it --rm \
		-v $(PWD):/app/ \
		-v $(PWD)/../reveal.js:/reveal.js/ \
		-w /app/ \
		--env AWS_ACCESS_KEY_ID \
		--env AWS_SECRET_ACCESS_KEY \
		$(DOCKER_IMAGE) apply -auto-approve

destroy:
	docker run -it --rm \
		-v $(PWD):/app/ \
		-w /app/ \
		--env AWS_ACCESS_KEY_ID \
		--env AWS_SECRET_ACCESS_KEY \
		$(DOCKER_IMAGE) destroy -auto-approve

console:
	docker run -it --rm \
		-v $(PWD):/app/ \
		-w /app/ \
		--env AWS_ACCESS_KEY_ID \
		--env AWS_SECRET_ACCESS_KEY \
		$(DOCKER_IMAGE) console

recreate: destroy apply
