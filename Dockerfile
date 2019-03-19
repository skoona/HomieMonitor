FROM ruby

EXPOSE 8585

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem update --system
RUN gem install bundler
RUN bundle install --path=vendor/bundle

COPY . .

ENV HM_MQTT_HOST=localhost
ENV HM_MQTT_PORT=1883
ENV HM_MQTT_USER=
ENV HM_MQTT_PASS=
ENV HM_BASE_TOPICS='[["homie/#",1]]'

RUN mkdir /tmp/homieMonitor
RUN touch /tmp/homieMonitor/paho-debug.log

RUN mkdir tmp
RUN mkdir tmp/pids
RUN touch tmp/pids/puma.pid

VOLUME /tmp/homieMonitor/

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]

