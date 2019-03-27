FROM ruby

WORKDIR /usr/src/app

# COPY Gemfile Gemfile.lock ./
COPY . .

RUN mkdir -p /tmp/homieMonitor && \
    touch /tmp/homieMonitor/paho-debug.log && \
    mkdir -p tmp/pids && \
    touch tmp/pids/puma.pid

RUN gem update --system && \
    gem install bundler
    
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 && \
    bundle install --path=vendor/bundle

# ENV HM_MQTT_HOST=localhost
# ENV HM_MQTT_PORT=1883
ENV HM_MQTT_USER=
ENV HM_MQTT_PASS=

ENV HM_BASE_TOPICS='[["sknSensors/#,0"],["homie/#",0]]'

ENV HM_MQTT_SSL_ENABLE_FLAG=false
ENV HM_MQTT_SSL_CERT_PATH=
ENV HM_MQTT_SSL_KEY_PATH=

ENV HM_OTA_TYPE='binary'

ENV RACK_ENV='production'

VOLUME /tmp/homieMonitor/
VOLUME /usr/src/app/content
VOLUME /usr/src/app/db
VOLUME /usr/src/app/config/settings

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
