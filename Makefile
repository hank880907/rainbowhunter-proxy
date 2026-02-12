.PHONY: proxy run

proxy:
	docker build -t rainbowhunter-proxy:latest application/

run:
	docker run -it --rm -p 25565:25565 -v $(PWD)/forwarding.secret:/etc/forwarding.secret rainbowhunter-proxy:latest
