.PHONY: build clean publish

# Variables
DOCKER_BUILD_COMMAND=DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64
DOCKER_IMAGE_NAME=switchboard-function

# Default make task
all: build

docker_build: 
	${DOCKER_BUILD_COMMAND} -t ${DOCKER_IMAGE_NAME} --load .
docker_publish: 
	${DOCKER_BUILD_COMMAND} -t ${DOCKER_IMAGE_NAME} --push .

build: docker_build measurement

publish: docker_publish measurement

measurement:
	@docker run -d --name my-switchboard-function $(DOCKER_IMAGE_NAME) > /dev/null
	@docker cp my-switchboard-function:/measurement.txt measurement.txt
	@docker stop my-switchboard-function > /dev/null
	@docker rm my-switchboard-function > /dev/null

# Task to clean up the compiled rust application
clean:
	cargo clean
