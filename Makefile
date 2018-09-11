NAME = cljfmt
VERSION ?= $(shell git describe --tags --abbrev=0)
GRAALVM_VERSION ?= 1.0.0-rc6
UBERJAR = target/cljfmt-graalvm-standalone.jar
PREFIX ?= /usr/local

export VERSION

$(NAME): $(UBERJAR)
	native-image -jar $(UBERJAR) -H:Name="$(NAME)"

.PHONY: packages
packages: deb

.PHONY: deb
deb:
	@mkdir -p dist
	debuild -us -uc -b
	@dh_clean
	mv ../$(NAME)* dist/

.PHONY: docker
docker: Dockerfile
	docker build --build-arg GRAALVM_VERSION=$(GRAALVM_VERSION) -t $(USER)/graalvm-lein:$(GRAALVM_VERSION) -t $(USER)/graalvm-lein:latest .

$(UBERJAR):
	lein uberjar

install:
	install -m 755 ./cljfmt $(PREFIX)/bin/
