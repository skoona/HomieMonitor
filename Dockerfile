# Single Stage
FROM arm64v8/ruby:3.0

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .

RUN bundle install


#	RUN mkdir -p ./log ./tmp/pids \
#	    # && apt install -y ruby-dev
#	    && gem install bundler \
#	    # && gem update --system 3.2.3 \
#		# && gem install libv8 -v '3.16.14.19' --source https://rubygems.org/
#	    && bundle config set --local path 'vendor/bundle'
#	    && bundle install 

ENV RACK_ENV='production'

EXPOSE 8585

ENTRYPOINT ["bundle", "exec", "puma", "config.ru"]
