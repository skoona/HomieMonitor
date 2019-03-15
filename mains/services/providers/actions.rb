# ##
# File: ./main/services/providers/actions.rb
# ##

# ##
# MessageTransport.new(formatted_topic_string, string_value)
#



module Services
  module Providers

    class Actions

      def self.call(command)
        self.new.call(command)
      end

      def initialize
        @_message_handler         = SknApp.registry.resolve("stream_handler")
        @_schedule_add_handler    = SknApp.registry.resolve("add_schedule_handler")
        @_schedule_delete_handler = SknApp.registry.resolve("delete_schedule_handler")
        @_start_time   = SknUtils.duration
        @description   = SknSettings.content_service.description
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      # Services::Commands::MessageTransport
      def call(cmd)
        resp = if cmd.valid?
                 case cmd.class.name.split('::').last
                 when  "MessageTransport"
                   @_message_handler.call(cmd.action, Homie::Commands::QueueEvent.new(cmd))
                 when "ScheduleDelete"
                   @_schedule_delete_handler.call(cmd.device_name)
                 when "ScheduleAdd"
                   @_schedule_add_handler.call(cmd.device_name, cmd.checksum)
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

