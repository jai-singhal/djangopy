CWD := $(shell pwd)

.PHONY: all
all: build

.PHONY: build
build: clean
	@gem build *.gemspec
	@echo ::: BUILD :::

.PHONY: push
push: build
	@gem push *.gem
	@echo ::: PUSH :::

.PHONY: clean
clean:
	-@rm -rf *.gem &>/dev/null || true
	@echo ::: CLEAN :::
