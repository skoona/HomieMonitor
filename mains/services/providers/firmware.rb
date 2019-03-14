# ##
# File: ./main/services/providers/actions.rb
# ##

# ##
# MessageTransport.new(formatted_topic_string, string_value)
#



module Services
  module Providers

    class Firmware

      def self.call(command)
        self.new.call(command)
      end

      def initialize
        @_send_handler = SknApp.registry.resolve("send_file_handler")
        @_recv_handler = SknApp.registry.resolve("receive_file_handler")
        @_delete_handler = SknApp.registry.resolve("delete_file_handler")
        @_schedule_handler = SknApp.registry.resolve("delete_schedule_handler")
        @_start_time   = SknUtils.duration
        @description   = SknSettings.content_service.description
      end

      # Services::Commands::ReceiveFile|SendFile
      def call(cmd)
        resp = if cmd.valid?
                case cmd.class.name.split('::').last
                when  "ReceiveFile"
                  @_recv_handler.call(cmd.filename, cmd.filesize, cmd.tempfile)
                when "SendFile"
                  @_send_handler.call(cmd)
                when "FirmwareDelete"
                  @_delete_handler.call(cmd.filename)
                when "ScheduledDelete"
                  @_schedule_handler.call(cmd.filename)
                else
                  SknSuccess.call( {success: false, status: 404, message: "Cannot Process Now!"}, "#{self.class.name}->[#{cmd.class.name}] #{@description}: Unknown Request type" )
                end
              end

        duration = SknUtils.duration(@_start_time)
        SknApp.logger.info "#{self.class.name}##{__method__} Command: #{cmd.class.name.split('::').last}, Returned: #{resp.class.name.split('::').last}, Duration: #{duration}"
        resp
      rescue StandardError => e
        duration = SknUtils.duration(@_start_time)
        msg =  "#{self.class.name}##{__method__} Failure Request: Provider: #{@description}, klass=#{e.class.name}, cause=#{e.message}, Duration: #{duration}, Backtrace=#{e.backtrace[0..1]}"
        SknApp.logger.warn(msg)
        SknFailure.call({success: false, status: 404, message: "#{self.class.name} rescued -> #{e.class.name}"},"#{self.class.name} -> [#{e.class.name}] #{e.message}, Duration: #{duration}")
      end

    end # end class
  end
end
# {"success": true, "error": "Development Mode", "reset": false}
