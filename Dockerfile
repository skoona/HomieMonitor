FROM ruby:2.6.2

RUN mkdir -p /homieMonitor

WORKDIR /homieMonitor

RUN mkdir -p ./log ./tmp/pids

RUN gem install bundler

# Copy the files needed for the bundle install
COPY ./Gemfile /homieMonitor/Gemfile
COPY ./Gemfile.lock /homieMonitor/Gemfile.lock

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 && \
    bundle install --path=vendor/bundle

COPY . /homieMonitor

ENV HM_MQTT_LOG=''
ENV RACK_ENV='production'

VOLUME /homieMonitor/config
VOLUME /homieMonitor/content
VOLUME /homieMonitor/log

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
