#! /bin/bash

# generate uuid
export container_name=$(uuidgen)
# assign uuid to running container name
echo 'running container to export'
echo "container name: $container_name"
docker run -id --name $container_name ruby-alpine:latest /usr/local/bin/ruby
# get pid of running container by uuid in name
export DockerID=$(docker ps | grep $container_name | awk '{print $1}')
# export container image by pid
echo 'exporting image to tar'
docker export $DockerID > latest.tar
# kill any running container with matching name
echo 'killing running container'
docker ps | grep $container_name | awk '{print $1}' | xargs docker kill
# clear pid environment variable
echo 'reset id variable'
DockerID=''
# import exported image as single layer
echo 'importing image'
# docker import --change "ENTRYPOINT [\"/usr/local/bin/irb\"]" latest.tar scratch-ruby:flat
# docker import --change "ENTRYPOINT [\"/usr/local/bin/ruby\", \"/app/bin/rails\", \"server\", \"--binding\", \"0.0.0.0\", \"--port\", \"3000\"]" \
docker import --change "CMD [\"/usr/local/bin/irb\"]" \
--change "WORKDIR /app" \
--change "ENV TERM=dumb" \
--change "ENV HOSTNAME=scratch_ruby" \
--change "ENV RUBY_DOWNLOAD_SHA256=d5d6da717fd48524596f9b78ac5a2eeb9691753da5c06923a6c31190abe01a62" \
--change "ENV RUBY_VERSION=2.6.5" \
--change "ENV PWD=/app" \
--change "ENV BUNDLE_APP_CONFIG=/usr/local/bundle" \
--change "ENV RUBY_MAJOR=2.6" \
--change "ENV HOME=/root" \
--change "ENV BUNDLE_SILENCE_ROOT_WARNING=1" \
--change "ENV GEM_HOME=/usr/local/bundle" \
--change "ENV SHLVL=1" \
--change "ENV BUNDLE_PATH=/usr/local/bundle" \
--change "ENV PATH=/usr/local/bundle/bin:/usr/local/bundle/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
latest.tar ruby-alpine:flat
# delete exported tar file
echo 'deleting image'
rm latest.tar