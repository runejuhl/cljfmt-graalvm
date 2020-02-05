NAME = cljfmt
VERSION ?= $(shell git describe --tags --always --dirty)
DOCKER_IMAGE ?= runejuhl/lein-graal:v19.2.1
UBERJAR = target/cljfmt-graalvm-standalone.jar
PREFIX ?= /usr/local
TARGET_DIR ?= build
NATIVE_BIN = $(TARGET_DIR)/$(NAME)
NATIVE_IMAGE_ARGS ?= --initialize-at-build-time --verbose --no-server

export VERSION

$(UBERJAR):
	lein uberjar

$(TARGET_DIR):

native: $(NATIVE_BIN)

.PHONY: graal
graal:
	native-image $(NATIVE_IMAGE_ARGS) -jar "$(UBERJAR)" -H:Name="$(NATIVE_BIN)"

$(NATIVE_BIN): $(UBERJAR)
	@mkdir -p $(TARGET_DIR)
	docker run -ti --rm \
		-e HOME=/tmp \
		-e VERSION=$(VERSION) \
		-u $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/app:ro \
		-v $(shell pwd)/$(TARGET_DIR):/app/$(TARGET_DIR):rw \
		-w /app \
		$(DOCKER_IMAGE) \
		make graal

.PHONY: build
build: $(NATIVE_BIN)

.PHONY: packages
packages: deb

.PHONY: deb
deb: $(NATIVE_BIN)
	debuild -us -uc -b
	mv -t ../$(NAME)_*

.PHONY: clean
clean:
	rm -rf ./$(TARGET_DIR)/*

release:
	gbp dch --auto --git-author --distribution=stable
