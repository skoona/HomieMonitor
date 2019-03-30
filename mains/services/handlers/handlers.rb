# File: ./main/services/handlers/handlers.rb

# Each Directory has a same named file that handles it's includes
# ##

module Services
  module Handlers
  end
end

require_relative 'stream'
require_relative 'receive_file'
require_relative 'settings'
require_relative 'delete_file'
require_relative 'delete_schedule'
require_relative 'delete_device'
require_relative 'add_schedule'
require_relative 'firmwares'


