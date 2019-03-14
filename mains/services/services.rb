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
    .register("content_provider",     ->(command)    { Services::Providers::Content.call(command) }, call: false)
    .register("content_action_provider", ->(command) { Services::Providers::Actions.call(command) }, call: false)
    .register("firmware_provider",    ->(command)    { Services::Providers::Firmware.call(command) }, call: false)
    .register("send_file_handler",    ->(command)    { Services::Handlers::SendFile.call(command) }, call: false)
    .register("receive_file_handler", ->(fname, fsize, tfile) { Services::Handlers::ReceiveFile.call(fname, fsize, tfile) }, call: false)
    .register("delete_file_handler",  ->(fname) { Services::Handlers::DeleteFile.call(fname) }, call: false)
    .register("delete_schedule_handler",  ->(device_name) { Services::Handlers::DeleteSchedule.call(device_name) }, call: false)
    .register("stream_handler",       ->(type, device_name)   { Services::Handlers::Stream.call(type,device_name) }, call: false)

