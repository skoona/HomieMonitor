# ##
# File: ./config/boot_web.rb
# - Instantiate Web Interface Entry: SknWeb
#

# Load Main Application
require_relative 'boot'

# Web Interface
begin

  # Load Web Interface
  require './web/web'

rescue LoadError, StandardError => ex
  $stderr.puts ex.message
  $stderr.puts ex.backtrace[0..8]
  exit 1
end
