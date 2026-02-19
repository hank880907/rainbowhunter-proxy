.PHONY: base extra run deploy-image

IMAGE_NAME = rainbowhunter-proxy
IMAGE_TAG = 0.0.8

# Build base image (Velocity + ViaVersion)
velocity:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) application/velocity/
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest

additional: velocity
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG)-additional application/additional/
	docker tag $(IMAGE_NAME):$(IMAGE_TAG)-additional $(IMAGE_NAME):latest-additional

# Run the extra image (default)
run-additional: additional
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret $(IMAGE_NAME):latest-additional

# Run base image
run: velocity
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret $(IMAGE_NAME):latest

# Deploy extra image to Docker Hub
deploy-image: additional
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):$(IMAGE_TAG)-additional $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)-additional
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)-additional
	docker tag $(IMAGE_NAME):$(IMAGE_TAG)-additional $(DOCKER_USERNAME)/$(IMAGE_NAME):latest-additional
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest-additional
	@echo "Image pushed to Docker Hub: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) and :latest"