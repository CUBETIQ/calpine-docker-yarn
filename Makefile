DOCKER_IMAGE=cubetiq/calpine-docker
DOCKER_IMAGE_NAME=${DOCKER_IMAGE}:20.10.7

build:
	@echo 'Starting docker build'
	docker build . -t ${DOCKER_IMAGE}

	@echo 'Starting docker push'
	docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE_NAME}
	docker push ${DOCKER_IMAGE}
	docker push ${DOCKER_IMAGE_NAME}

.PHONY:build