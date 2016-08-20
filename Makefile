.PHONY: discovery_url

discovery_url:
	@curl -w '\n' https://discovery.etcd.io/new?size=$(shell grep -A 2 count variables.tf| grep '[0-9]' | cut -d= -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$$//')
