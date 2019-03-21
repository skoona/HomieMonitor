# ##
# ./Gemfile

source "https://rubygems.org"

gem 'logging'

# Web framework: Core
gem "puma"
gem "roda"

# Web framework: Html
gem "tilt"
gem "erubis"
gem 'forme'
gem 'roda-tags'
gem 'sass' # 'sassc'
gem 'tilt-pipeline'

# Javascript Runtime Support
gem 'execjs'
gem "therubyracer", platform: :ruby
gem 'therubyrhino', platform: :jruby, require: "rhino"
gem 'yui-compressor'
# gem 'uglifier'

# Core Components
gem 'skn_utils'
gem 'dry-struct'
gem 'dry-container'
gem 'dry-configurable'


# General Utilities
gem 'concurrent-ruby', require: 'concurrent'
gem 'time_math2', require: 'time_math'
gem 'mime-types'
gem "r18n-core"
gem "roda-i18n"

# Persistence
# YAML::Store

# Web Security
gem 'rack-contrib'
gem "rack-protection"
gem "rack_csrf"

gem "jruby-jars", "9.2.6.0", platform: :jruby
gem "rake"

# MQTT Support
gem 'paho-mqtt'
gem "deep_merge", '~> 1'

group :development, :test do
  gem 'pry'
  gem "rubocop", require: false
  gem "warbler", require: false, platform: :jruby
end

group :test do
  gem 'rspec'
  gem 'faker'
  gem 'rack-test'
  gem 'rspec-roda'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'rack_session_access'
  gem 'simplecov', :require => false
  gem 'poltergeist'
  gem 'webmock'
end
