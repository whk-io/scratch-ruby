build:
	docker build -t scratch-ruby .
	#./flatten.sh

irb:
	docker run -it scratch-ruby:flat irb

alpine:
	docker build -t ruby-alpine -f Docker.alpine .
	./flatten-alpine.sh