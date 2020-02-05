NAME = cljfmt
VERSION ?= $(shell git describe --tags --abbrev=0)
DOCKER_IMAGE ?= runejuhl/lein-graal:v19.2.1
UBERJAR = target/cljfmt-graalvm-standalone.jar
PREFIX ?= /usr/local
TARGET_DIR ?= ./bin
NATIVE_BIN = $(TARGET_DIR)/$(NAME)
NATIVE_IMAGE_ARGS ?= --initialize-at-build-time --verbose --no-server

export VERSION

$(UBERJAR):
	lein uberjar

$(TARGET_DIR):
	mkdir -p $(@)

native: $(NATIVE_BIN)

$(NATIVE_BIN): $(TARGET_DIR) docker

.PHONY: graal
graal:
	native-image $(NATIVE_IMAGE_ARGS) -jar "$(UBERJAR)" -H:Name="$(NATIVE_BIN)"

docker: $(UBERJAR)
	docker run -ti --rm -e HOME=/tmp -e VERSION=$(VERSION) -u $(shell id -u):$(shell id -g) -v $(shell pwd):/app:ro -v $(shell pwd)/$(TARGET_DIR):/app/$(TARGET_DIR):rw -w /app $(DOCKER_IMAGE) make graal

.PHONY: build
build: $(NAME)

.PHONY: packages
packages: dist deb

dist:
	@mkdir -p dist

.PHONY: deb
deb: $(NAME)
	debuild -us -uc -b
	mv ../$(NAME)*.deb dist/

.PHONY: clean
clean:
	rm -f dist/*
