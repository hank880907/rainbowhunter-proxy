.PHONY: base extra run deploy

IMAGE_NAME = rainbowhunter-proxy
IMAGE_TAG = 0.0.2

# Build base image (Velocity + ViaVersion)
velocity:
	docker build -t $(IMAGE_NAME):velocity application/velocity/

# Build extra image (extends base with additional plugins)
proxy: velocity
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) application/proxy/

proxy-additional: proxy
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG)-additional application/proxy-additional/

# Run the extra image (default)
run-additional: proxy-additional
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret $(IMAGE_NAME):$(IMAGE_TAG)-additional

# Run base image
run: proxy
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret $(IMAGE_NAME):$(IMAGE_TAG)

# Deploy extra image to Docker Hub
deploy-image: extra
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):$(IMAGE_TAG)-additional $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)-additional
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)-additional
	docker tag $(IMAGE_NAME):$(IMAGE_TAG)-additional $(DOCKER_USERNAME)/$(IMAGE_NAME):latest-additional
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest-additional
	@echo "Image pushed to Docker Hub: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) and :latest"