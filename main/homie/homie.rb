# File: ./main/homie/homie.rb

# ##
# Each Directory has a same named file that handles it's includes
# ##


module Homie
end

require_relative 'commands/commands'
require_relative 'events/events'
require_relative 'component/component'
require_relative 'handlers/handlers'
require_relative 'manager'

# ##
# Configure streamers
SknApp.registry
    .register("stream_receive_queue", Queue.new,  call: false)
    .register("stream_send_queue", Queue.new, call: false)
    .register("device_stream_manager", ->() { Homie::Manager.instance }, call: true)

  if SknSettings.content_service.demo_mode
    SknApp.registry.register("device_stream_listener", ->() { Homie::Handlers::MockStream.call() }, call: false)
  else
    SknApp.registry.register("device_stream_listener", ->() { Homie::Handlers::Stream.call }, call: false)
  end