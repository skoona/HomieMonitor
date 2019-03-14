# File: ./main/homie/homie.rb

# ##
# Each Directory has a same named file that handles it's includes
# ##


module Homie
end

require_relative 'commands/commands'
require_relative 'events/events'
require_relative 'components/components'
require_relative 'handlers/handlers'
require_relative 'manager'

# ##
# Configure streamers
SknApp.registry
    .register("stream_receive_queue", Queue.new,  call: false)
    .register("stream_send_queue", Queue.new, call: false)
    .register("device_stream_manager", ->() { Homie::Manager.instance }, call: true)
    .register("data_source", ->(){ YAML::Store.new(SknSetting.content_service.data_source.store, true) }, call: true)
    .register("subscriptions_provider", ->(){ Homie::Events::Provider.instance }, call: true)

  if SknSettings.content_service.demo_mode or SknSettings.mqtt.host.eql?('some.fqdn.com')
    SknApp.registry.register("device_stream_listener", ->() { Homie::Handlers::MockStream.call() }, call: false)
  else
    SknApp.registry.register("device_stream_listener", ->() { Homie::Handlers::Stream.call }, call: false)
  end