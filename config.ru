#
# File: ./config.ru

require 'puma'
require_relative "config/boot_web"

app = case SknApp.env
        when 'development', 'test'
          SknWeb.app
        else
          SknWeb.freeze.app
      end

run app
