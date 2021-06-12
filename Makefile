NAME = cljfmt
VERSION ?= $(shell git describe --tags --always --dirty)
DOCKER_IMAGE ?= runejuhl/lein-graal:21.1.0
UBERJAR = target/cljfmt-graalvm-standalone.jar
PREFIX ?= /usr/local
TARGET_DIR ?= build
NATIVE_BIN = $(TARGET_DIR)/$(NAME)
NATIVE_IMAGE_ARGS ?= --initialize-at-build-time --verbose --no-server

export VERSION

$(NATIVE_BIN): $(UBERJAR)
	@mkdir -p $(TARGET_DIR)
	native-image $(NATIVE_IMAGE_ARGS) -jar "$(UBERJAR)" -H:Name="$(NATIVE_BIN)"

$(UBERJAR):
	lein uberjar

.PHONY: build
build: $(NATIVE_BIN)

build/docker: $(UBERJAR)
	@mkdir -p $(TARGET_DIR)
	docker run -ti --rm \
		-e HOME=/tmp \
		-e VERSION=$(VERSION) \
		-u $(shell id -u):$(shell id -g) \
		-v $(PWD):/app:ro \
		-v $(PWD)/$(TARGET_DIR):/app/$(TARGET_DIR):rw \
		-w /app \
		$(DOCKER_IMAGE) \
		make build

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
