FROM ruby:2.6.2

WORKDIR . 

COPY . .

RUN mkdir -p ./log ./tmp/pids &&\
    gem install bundler &&\
    bundle install --path=vendor/bundle

ENV RACK_ENV='production'

VOLUME /config
VOLUME /content
VOLUME /log

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
