IMG       = bsorahan/dotnet-docker-hello-world
MANIFEST  = $(IMG):latest
IMG_AMD64 = $(MANIFEST)-amd64
IMG_ARM64 = $(MANIFEST)-arm64
SRC       = $(wildcard *.cs) $(wildcard *.csproj)

all: .arm64-build .amd64-build

.amd64-build: .multiarch Dockerfile $(SRC)
	@docker buildx build --platform linux/amd64 --load -t $(IMG_AMD64) -f $< .
	@touch $@

.arm64-build: .multiarch Dockerfile.arm $(SRC)
	@docker buildx build --platform linux/arm64 --load -t $(IMG_ARM64) -f $< .
	@touch $@

 .multiarch:
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@-docker buildx rm builder
	@docker buildx create --name builder --driver docker-container --use
	@touch $@

clean:
	@rm -rf .amd64-build .arm64-build .multiarch

push: .amd64-build .arm64-build create-manifest
	@docker push $(IMG_AMD64)
	@docker push $(IMG_ARM64)

create-manifest:
	@-docker manifest create         $(MANIFEST) $(IMG_AMD64) $(IMG_ARM64)
	@-docker manifest create --amend $(MANIFEST) $(IMG_AMD64) $(IMG_ARM64)

.PHONY: all clean prepare-multi-arch-builder push
