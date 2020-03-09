SHELL = bash -o pipefail

containers:
	docker buildx build --platform linux/amd64,linux/arm64 -t cseelye/ledserver --push .
