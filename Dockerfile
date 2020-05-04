# FROM ruby:2.6.5-slim-buster as ruby
FROM ruby@sha256:b0eeb50a5a53bcec81fa45e4884b53dd22907811c105b74e1bb791d506fce439 as ruby

ENV TERM=dumb

RUN apt-get update -y && apt-get install -y build-essential libsqlite3-dev busybox
COPY Gemfile /app/Gemfile
COPY scratch_helper.rb /app/scratch_helper.rb
WORKDIR /app
RUN gem install bundle && bundle install
RUN echo "3"
RUN ./scratch_helper.rb

# RUN ldd /usr/local/bin/ruby

FROM scratch

ENV TERM=dumb
ENV HOSTNAME=scratch_ruby
ENV RUBY_DOWNLOAD_SHA256=UPDATE_ME
ENV RUBY_VERSION=2.6.6
ENV PWD=/app
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV RUBY_MAJOR=2.6
ENV HOME=/root
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV GEM_HOME=/usr/local/bundle
ENV SHLVL=1
ENV BUNDLE_PATH=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:/usr/local/bundle/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /app

# -- Test script for reflective static library detection
COPY --from=ruby /usr/bin/ldd /usr/bin/ldd
COPY --from=ruby /usr/local/bin/ruby /usr/local/bin/ruby
COPY --from=ruby /app/scratch_helper.rb /app/scratch_helper.rb

# -- from distroless_ruby
COPY --from=ruby /lib/arm-linux-gnueabihf/libz.so.* /lib/arm-linux-gnueabihf/
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libyaml* /usr/lib/arm-linux-gnueabihf/
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libgmp* /usr/lib/arm-linux-gnueabihf/

COPY --from=ruby /usr/local/lib/ /usr/local/lib
COPY --from=ruby /usr/local/bin/ /usr/local/bin

# -- from scratch_helper.rb
COPY --from=ruby /usr/local/lib/libruby.so.2.6 /usr/local/lib/libruby.so.2.6

COPY --from=ruby /lib/arm-linux-gnueabihf/libm.so.6 /lib/arm-linux-gnueabihf/libm.so.6
COPY --from=ruby /lib/arm-linux-gnueabihf/libc.so.6 /lib/arm-linux-gnueabihf/libc.so.6
COPY --from=ruby /lib/arm-linux-gnueabihf/libz.so.1 /lib/arm-linux-gnueabihf/libz.so.1
COPY --from=ruby /lib/arm-linux-gnueabihf/libpthread.so.0 /lib/arm-linux-gnueabihf/libpthread.so.0
COPY --from=ruby /lib/arm-linux-gnueabihf/librt.so.1 /lib/arm-linux-gnueabihf/librt.so.1
COPY --from=ruby /lib/arm-linux-gnueabihf/libdl.so.2 /lib/arm-linux-gnueabihf/libdl.so.2
COPY --from=ruby /lib/arm-linux-gnueabihf/libcrypt.so.1 /lib/arm-linux-gnueabihf/libcrypt.so.1

COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libsqlite3.so.0 /usr/lib/arm-linux-gnueabihf/libsqlite3.so.0
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libgmp.so.10 /usr/lib/arm-linux-gnueabihf/libgmp.so.10


# -- undetected
COPY --from=ruby /usr/local/bundle/extensions /usr/local/bundle/extensions
#COPY --from=ruby /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=ruby /lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3

COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libffi.a /usr/lib/arm-linux-gnueabihf/libffi.a
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libffi.so.6.0.4 /usr/lib/arm-linux-gnueabihf/libffi.so.6.0.4
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libffi.so /usr/lib/arm-linux-gnueabihf/libffi.so
COPY --from=ruby /usr/lib/arm-linux-gnueabihf/libffi.so.6 /usr/lib/arm-linux-gnueabihf/libffi.so.6

CMD ["/usr/local/bin/ruby", "-v"]