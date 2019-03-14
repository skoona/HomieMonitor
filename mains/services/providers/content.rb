# ##
# File: ./main/services/providers/content.rb
# ##

# ##
# HomieCatalog.(collection:, key:)
# HomieBroadcasts.(collection:)
#



module Services
  module Providers

    class Content

      def self.call(command)
        self.new.call(command)
      end

      def initialize
        @_do_request   = SknApp.registry.resolve("stream_handler")
        @_start_time   = SknUtils.duration
        @description   = SknSettings.content_service.description
      end

      # Services::Content::Commands::HomieDevices, HomieBroadcasts
      def call(cmd)
        resp = cmd.valid? ? process(cmd) : SknFailure.call( self.class.name, "[#{cmd.class.name}] #{@description}: Unknown Request type" )
        if cmd.collection.eql?("management") and resp.success
          resp = add_firmware_inventory(resp)
        end

        duration = SknUtils.duration(@_start_time)
        logger.info "#{self.class.name}##{__method__} Command: #{cmd.class.name.split('::').last}, Returned: #{resp.class.name.split('::').last}, Duration: #{duration}"
        resp
      rescue StandardError => e
        duration = SknUtils.duration(@_start_time)
        logger.warn "#{self.class.name}##{__method__} Failure Request: Provider: #{@description}, klass=#{e.class.name}, cause=#{e.message}, Duration: #{duration}, Backtrace=#{e.backtrace[0..1]}"
        SknFailure.call(self.class.name, "#{e.class.name}::#{e.message}, Duration: #{duration}")
      end

      # SknSuccess or SknFailure
      def process(cmd)
        @_do_request.call(cmd.collection, cmd.device_name)
      end

      def add_firmware_inventory(resp)
        SknSuccess.(
            {
                  devices: resp.value[:package],
                scheduled: [resp.value[:package]&.first].compact,
                  catalog: firmware_inventory
            },
            resp.message
        )
      end

      def firmware_inventory
        Dir[SknSettings.content_service.firmware_path + "*"].map do |fware|
          Homie::Components::Firmware.new(fware).to_hash
        end
      end

      def logger
        Logging.logger['HMIE']
      end

    end # end class

  end
end

