NAME = tkellen/image-pipe

default: build

build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

run:
	docker run --rm $(NAME)

release: build push
