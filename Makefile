# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: build clean publish test

# Variables
CARGO_NAME=switchboard-function # Cargo.toml name
DOCKERHUB_IMAGE_NAME=switchboardlabs/my-function # Docker registry image name

check_docker_env:
ifeq ($(strip $(DOCKERHUB_IMAGE_NAME)),)
	$(error DOCKERHUB_IMAGE_NAME is not set)
else
	@echo DOCKERHUB_IMAGE_NAME: ${DOCKERHUB_IMAGE_NAME}
endif

DOCKER_BUILD_COMMAND=DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64 --build-arg CARGO_NAME=${CARGO_NAME}

# Default make task
all: build

docker_build: check_docker_env
	${DOCKER_BUILD_COMMAND} --pull -f Dockerfile -t ${DOCKERHUB_IMAGE_NAME} --load ./
docker_publish: check_docker_env
	${DOCKER_BUILD_COMMAND} --pull -f Dockerfile -t ${DOCKERHUB_IMAGE_NAME} --push ./

build: docker_build measurement

publish: docker_publish measurement

measurement: check_docker_env
	docker pull --platform=linux/amd64 -q ${DOCKERHUB_IMAGE_NAME}:latest
	@docker run -d --platform=linux/amd64 -q --name=my-switchboard-function ${DOCKERHUB_IMAGE_NAME}:latest
	@docker cp my-switchboard-function:/measurement.txt ./measurement.txt
	@echo -n 'MrEnclve: '
	@cat measurement.txt
	@docker stop my-switchboard-function > /dev/null
	@docker rm my-switchboard-function > /dev/null

# Task to clean up the compiled rust application
clean:
	cargo clean
