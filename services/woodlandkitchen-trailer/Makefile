IMAGE_NAME = tkellen/$(shell basename $(CURDIR))

PHONY: build run publish

build:
	docker build -t $(IMAGE_NAME):latest .

run: build
	docker run -p 8080:80 $(IMAGE_NAME)

publish:
	docu
