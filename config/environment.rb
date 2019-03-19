# ##
# File: ./config/environment.rb
# - Initialize Minimal Application Environment
#

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Instantiate Resources
begin

  require 'bundler/setup' # Setup LoadPath for gems listed in the Gemfile.

  if defined?(JRUBY_VERSION)
    require 'java'
    $stdout.puts("Using JRuby and requiring JAVA!")
  else
    $stdout.puts("Using Ruby #{RUBY_PLATFORM}")
  end

  require_relative 'version'              # Skn::Version

  # Ruby Standard Library Modules
  require 'deep_merge'
  require 'json'
  require 'erb'
  require 'pathname'
  require "securerandom"
  require "net/http"
  require "uri"
  require "mime/types"
  require 'digest'
  require 'base64'
  require 'fileutils'
  require "psych"
  require 'yaml/store'

  Bundler.require(:default, ENV['RACK_ENV'].to_sym) # Require all the gems for this environment

  require "paho-mqtt"

  Dir["./config/initializers/**/*.rb"].sort.each do |pgm_resource|
    begin
      require pgm_resource
    rescue LoadError => e
      puts "[Boot] Ignoring Exception for: #{e.class} #{e.message}"
    end
  end

rescue Bundler::BundlerError, StandardError => ex
  $stderr.puts ex.message
  $stderr.puts ex.backtrace[0..8]
  if ex.is_a?(Bundler::BundlerError)
    $stderr.puts "Run `bundle install` to install missing gems"
    exit ex.status_code
  else
    exit 1
  end
end

