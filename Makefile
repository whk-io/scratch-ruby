build:
	docker build -t scratch-ruby .
	./flatten.sh

alpine:
	docker build -t ruby-alpine -f Docker.alpine .
	./flatten-alpine.sh