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
        @_do_request   = SknApp.registry.resolve("stream_handler")
        @_start_time   = SknUtils.duration
        @description   = SknSettings.content_service.description
      end

      # Services::Commands::MessageTransport
      def call(cmd)
        resp = cmd.valid? ? process(cmd) : SknSuccess.call( {success: false, status: 404, message: "Add to send_queue failed!"}, "#{self.class.name}->[#{cmd.class.name}] #{@description}: Unknown Request type" )
        duration = SknUtils.duration(@_start_time)
        SknApp.logger.info "#{self.class.name}##{__method__} Command: #{cmd.class.name.split('::').last}, Returned: #{resp.class.name.split('::').last}, Duration: #{duration}"
        resp
      rescue StandardError => e
        duration = SknUtils.duration(@_start_time)
        msg =  "#{self.class.name}##{__method__} Failure Request: Provider: #{@description}, klass=#{e.class.name}, cause=#{e.message}, Duration: #{duration}, Backtrace=#{e.backtrace[0..1]}"
        SknApp.logger.warn(msg)
        SknFailure.call({success: false, status: 404, message: "#{self.class.name} rescued -> #{e.class.name}"},"#{self.class.name} -> [#{e.class.name}] #{e.message}, Duration: #{duration}")
      end

      # SknSuccess or SknFailure
      def process(cmd)
        @_do_request.call(cmd.action, Homie::Commands::QueueEvent.new(cmd))
      end

    end # end class

  end
end

