# Variables
FLOGO_FILE=flogo-graphql.flogo
IMAGE_NAME=flogo-graphql
TAG=latest
CONTAINER_NAME=flogo-graphql-container
REGISTRY=registry.vmlab.live
FLOGO_CONTEXT=default

# Default target
.PHONY: all
all: build

.PHONY: build
build: build-binary build-container

.PHONY: build-binary
build-binary:
	flogo-cli build-exe -c ${FLOGO_CONTEXT} -n ./bin/${IMAGE_NAME} -f ./${FLOGO_FILE}

# Build the Docker image
.PHONY: build-container
build-container:
	docker build -t $(IMAGE_NAME):$(TAG) .

# Tag the Docker image
.PHONY: tag
tag:
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(TAG)
	docker tag $(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):$(TAG) 

# Push image to the registry
.PHONY: push
push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG) 

# Run the Docker container
.PHONY: run
run:
	docker run -d --rm --name $(CONTAINER_NAME) -e FLOGO_LOG_LEVEL=INFO -e FLOGO_RUNNER_TYPE=DIRECT -p 9999:9999 $(IMAGE_NAME):$(TAG)

# Stop the Docker container
.PHONY: stop
stop:
	docker stop $(CONTAINER_NAME)

# Remove the Docker image
.PHONY: remove-image
remove:
	docker rmi $(IMAGE_NAME):$(TAG)

.PHONY:  remove-binary
remove-binary:
	rm ./bin/${IMAGE_NAME}

# Clean up images and containers
.PHONY: clean
clean: stop remove-image remove-binary

