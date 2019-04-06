FROM ruby

WORKDIR /usr/src/app

COPY . .

RUN mkdir -p ./log && \
    mkdir -p ./tmp/pids && \
    touch ./tmp/pids/puma.pid

RUN gem update --system && \
    gem install bundler
    
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 && \
    bundle install --path=vendor/bundle

ENV HM_BASE_TOPICS='[["sknSensors/#,0"],["homie/#",0]]'
ENV HM_MQTT_LOG=''
ENV RACK_ENV='production'

VOLUME /usr/src/app

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
