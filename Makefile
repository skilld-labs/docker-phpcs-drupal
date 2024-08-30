NAME = skilldlabs/docker-phpcs-drupal
TAGS ?= 10

DOCKER_BUILDKIT ?= 1

.PHONY: all build push

all: build push

build:
	@echo "Building images for tags: $(TAGS)"
	set -e; for i in $(TAGS); do printf "\nBuilding $(NAME):$$i \n\n"; cd drupal$$i; \
		DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build -t $(NAME):$$i \
		--pull --no-cache --progress=plain \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=`git rev-parse --short HEAD` .; \
		cd ..; done

push:
	@echo "Pushing images for tags: $(TAGS)"
	set -e; for i in $(TAGS); do printf "\nPushing $(NAME):$$i \n\n"; docker push $(NAME):$$i; done
