UNAME:=$(shell uname -s | tr A-Z a-z)
ifeq ($(UNAME), linux)
GOOS?=linux
GOARCH?=amd64
else ifeq ($(UNAME), darwin)
GOOS?=darwin
GOARCH?=amd64
endif

.PHONY: all build show
all: build

.PHONY: build
build: build-$(GOOS)

build-linux:
	echo build linux: $(GOOS) $(GOARCH)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o sample-$(shell echo $(GOOS) | tr A-Z a-z) ./sample.go

build-darwin:
	echo build linux: $(GOOS) $(GOARCH)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o sample-$(shell echo $(GOOS) | tr A-Z a-z) ./sample.go

