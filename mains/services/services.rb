# File: ./strategy/services/services.rb

# ##
#  Local Exceptions
# ##

module Services
end

class CommandFailedValidation < StandardError
end

# ##
# Each Directory has a same named file that handles it's includes
# ##

require_relative 'commands/commands'
require_relative 'handlers/handlers'
require_relative 'providers/providers'
require_relative 'services_registry'

# ##
# Configure our command processors
SknApp.registry
    .register("content_provider",        ->(command) { Services::Providers::Content.call(command) }, call: false)
    .register("content_action_provider", ->(command) { Services::Providers::Actions.call(command) }, call: false)
    .register("firmware_provider",       ->(command) { Services::Providers::Firmware.call(command) }, call: false)
    .register("firmware_catalog",        ->(action, value) { Services::Handlers::Firmwares.call(action, value) }, call: false)
    .register("add_schedule_handler",    ->(device_name, checksum) { Services::Handlers::AddSchedule.call(device_name, checksum) }, call: false)
    .register("delete_schedule_handler", ->(device_name) { Services::Handlers::DeleteSchedule.call(device_name) }, call: false)
    .register("send_file_handler",       ->(command) { Services::Handlers::SendFile.call(command) }, call: false)
    .register("receive_file_handler",    ->(fname, fsize, tfile) { Services::Handlers::ReceiveFile.call(fname, fsize, tfile) }, call: false)
    .register("delete_file_handler",     ->(fname)   { Services::Handlers::DeleteFile.call(fname) }, call: false)

# ##
# Configure streamers
SknApp.registry
    .register("stream_handler",       ->(type, device_name) { Services::Handlers::Stream.call(type,device_name) }, call: false)
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
