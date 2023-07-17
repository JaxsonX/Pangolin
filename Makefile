# PROJECT = $(shell whoami)
# VERSION = 1.0_dev_$(shell  date "+%Y%m%d%H%M")
# DOCKER_TAG = viewer/$(PROJECT):$(VERSION)

build_base_docker_image:
	docker build --no-cache --tag viewer:v0.1.0 --file docker/Dockerfile.base .
	-docker rmi $(docker images -f "dangling=true" -q)

run_in_docker:
	docker run --rm --name $(PROJECT) -it $(DOCKER_TAG)

build_dev:
	docker rm -f viewer_dev
	docker build --no-cache --tag viewer_dev --file docker/Dockerfile.dev .
	docker run -d --ipc=host --net=host --privileged=false \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-e DISPLAY=unix$(DISPLAY) \
		-v /usr/bin/docker:/usr/bin/docker \
		--rm --name viewer_dev \
		-it viewer:v0.1.0

hook:
	git config core.hooksPath .githooks

clean:
	git clean -f -d -x

clean-dry-run:
	git clean -n -d -x
