FROM ruby:2.6.5-slim-buster as ruby
RUN apt-get update -y && apt-get install -y build-essential libsqlite3-dev
COPY Gemfile /app/Gemfile
WORKDIR /app
RUN gem install bundle && bundle install
RUN ldd /usr/local/bin/ruby

FROM scratch

COPY --from=ruby /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=ruby /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=ruby /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1
COPY --from=ruby /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=ruby /lib/x86_64-linux-gnu/libcrypt.so.1 /lib/x86_64-linux-gnu/libcrypt.so.1
COPY --from=ruby /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6 
COPY --from=ruby /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libgmp.so.10 /usr/lib/x86_64-linux-gnu/libgmp.so.10
COPY --from=ruby /usr/local/lib/libruby.so.2.6 /usr/local/lib/libruby.so.2.6
COPY --from=ruby /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=ruby /lib/x86_64-linux-gnu/libz.so.* /lib/x86_64-linux-gnu/
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libyaml* /usr/lib/x86_64-linux-gnu/
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libgmp* /usr/lib/x86_64-linux-gnu/
COPY --from=ruby /usr/local/lib/ /usr/local/lib
COPY --from=ruby /usr/local/bin/ /usr/local/bin

COPY --from=ruby /usr/local/bundle /usr/local/bundle
#COPY --from=ruby /usr/local/bundle/ruby /usr/local/bundle/ruby
COPY --from=ruby /usr/local/bundle/extensions /usr/local/bundle/extensions

COPY --from=ruby /usr/include/sqlite3.h /usr/include/sqlite3.h
COPY --from=ruby /usr/include/sqlite3ext.h /usr/include/sqlite3ext.h
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libsqlite3.a /usr/lib/x86_64-linux-gnu/libsqlite3.a
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libsqlite3.la /usr/lib/x86_64-linux-gnu/libsqlite3.la
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libsqlite3.so /usr/lib/x86_64-linux-gnu/libsqlite3.so
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6
COPY --from=ruby /usr/lib/x86_64-linux-gnu/pkgconfig/sqlite3.pc /usr/lib/x86_64-linux-gnu/pkgconfig/sqlite3.pc

COPY --from=ruby /usr/lib/x86_64-linux-gnu/libffi.a /usr/lib/x86_64-linux-gnu/libffi.a
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libffi.so /usr/lib/x86_64-linux-gnu/libffi.so
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libffi.so.6 /usr/lib/x86_64-linux-gnu/libffi.so.6
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libffi.so.6.0.4 /usr/lib/x86_64-linux-gnu/libffi.so.6.0.4

ENV TERM=dumb
ENV HOSTNAME=distroless_ruby
ENV RUBY_DOWNLOAD_SHA256=d5d6da717fd48524596f9b78ac5a2eeb9691753da5c06923a6c31190abe01a62
ENV RUBY_VERSION=2.6.5
ENV PWD=/app
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV RUBY_MAJOR=2.6
ENV HOME=/root
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV GEM_HOME=/usr/local/bundle
ENV SHLVL=1
ENV BUNDLE_PATH=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:/usr/local/bundle/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/busybox

WORKDIR /app


CMD ["/usr/local/bin/ruby", "-v"]