IMAGE_NAME = tkellen/$(shell basename $(CURDIR))
SSH_HOST = ubuntu@thewoodlandkitchen.com

PHONY: build run publish

build:
	docker build -t $(IMAGE_NAME):latest .

run: build
	docker run -p 8080:80 $(IMAGE_NAME)

ssh:
	ssh $(SSH_HOST)

provision:
	scp provisioning/nginx.conf $(SSH_HOST):~/
	ssh $(SSH_HOST) sudo apt-get update
	ssh $(SSH_HOST) sudo apt-get -y install nginx
	ssh $(SSH_HOST) sudo rm -f /etc/nginx/sites-enabled/default
	ssh $(SSH_HOST) sudo mv ~ubuntu/nginx.conf /etc/nginx/sites-enabled
	ssh $(SSH_HOST) sudo systemctl restart nginx
	ssh $(SSH_HOST) sudo chown ubuntu:ubuntu /var/www

deploy:
	rsync -az --force --delete --progress ./trailer ubuntu@thewoodlandkitchen.com:/var/www/
