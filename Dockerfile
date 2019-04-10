# 1st Stage
FROM ruby:2.6.2 AS builder

COPY . /app
COPY ./Gemfile ./Gemfile.lock  /app/

WORKDIR /app

ENV RACK_ENV='production'

RUN mkdir -p /app/{log,tmp/pids} \
    && gem install bundler \
    && bundle install --path=vendor/bundle --deployment

VOLUME /app/config /app/content /app/log

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
