# 1st Stage
FROM ruby:2.6.2 AS builder

COPY . /app
COPY ./Gemfile ./Gemfile.lock  /app/

WORKDIR /app

RUN mkdir -p /app/{log,tmp/pids} \
    && gem install bundler \
    && bundle install --path=vendor/bundle --deployment

# 2nd Stage
FROM ruby:2.6.2

WORKDIR /app

COPY --from=builder /app /app

ENV RACK_ENV='production'

VOLUME /app/config /app/content /app/log

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
