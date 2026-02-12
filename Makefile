.PHONY: proxy run deploy

IMAGE_NAME = rainbowhunter-proxy
IMAGE_TAG = 0.0.1

proxy:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) application/

run: proxy
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret $(IMAGE_NAME):$(IMAGE_TAG)

deploy: proxy
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	@echo "Image pushed to Docker Hub: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) and :latest"