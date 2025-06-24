# Variables
FLOGO_FILE=flogo-graphql.flogo
IMAGE_NAME=flogo-graphql
TAG=latest
CONTAINER_NAME=flogo-graphql-container
REGISTRY=registry.vmlab.live
FLOGO_CONTEXT=130

# Default target
.PHONY: all
all: build

.PHONY: build
build: build-binary build-container

.PHONY: build-binary
build-binary:
	flogo-cli build-exe -c ${FLOGO_CONTEXT} -n ./bin/${IMAGE_NAME} -f ./app/${FLOGO_FILE}

# Build the Docker image
.PHONY: build-container
build-container:
	docker build -t $(IMAGE_NAME):$(TAG) .

# Tag the Docker image
.PHONY: docker-tag
docker-tag:
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(TAG)
	docker tag $(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):$(TAG) 

# Push image to the registry
.PHONY: docker-push
docker-push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG) 

# Run the Docker container
.PHONY: docker-run
docker-run:
	docker run -d --network mongo-network --rm --name $(CONTAINER_NAME) -e FLOGO_LOG_LEVEL=INFO -e FLOGO_RUNNER_TYPE=DIRECT -p 4000:4000 $(IMAGE_NAME):$(TAG)

# Stop the Docker container
.PHONY: docker-stop
docker-stop:
	docker stop $(CONTAINER_NAME)

# Remove the Docker image
.PHONY: docker-rmi
docker-rmi:
	docker rmi $(IMAGE_NAME):$(TAG)

.PHONY:  remove-binary
remove-binary:
	rm ./bin/${IMAGE_NAME}

# Clean up images and containers
.PHONY: clean
clean: stop remove-image remove-binary

