#
# File: ./config.ru

require 'puma'
require_relative "config/boot_web"

app = SknWeb.freeze.app

run app
