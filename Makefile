IMG       = bsorahan/dotnet-docker-hello-world
IMG_AMD64 = bsorahan/dotnet-docker-hello-world:latest-amd64
IMG_ARM64 = bsorahan/dotnet-docker-hello-world:latest-arm64

all: images

images: .arm64-build .amd64-build

.amd64-build: Dockerfile
	@docker buildx build --platform linux/amd64 -t $(IMG_AMD64) -f $< .
	@touch $@

.arm64-build: Dockerfile.arm
	@docker buildx build --platform linux/arm64 -t $(IMG_ARM64) -f $< .
	@touch $@

clean:
	@rm -rf .amd64-build .arm64-build

push: amd64-push arm64-push

amd64-push: .amd64-build
	@docker push $(IMG_AMD64)

arm64-push: .arm64-build
	@docker push $(IMG_ARM64)

.PHONY: all amd64-push arm64-push clean images push
