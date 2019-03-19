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
        @_stream     = SknApp.registry.resolve("stream_handler")
        @_firmwares  = SknApp.registry.resolve("firmware_catalog")
        @_subscriptions = SknApp.registry.resolve("subscriptions_provider")
        @_start_time = SknUtils.duration
        @description = SknSettings.content_service.description
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      # Services::Content::Commands::HomieDevices, HomieBroadcasts
      def call(cmd)
        resp = cmd.valid? ? process(cmd) : SknFailure.call( self.class.name, "[#{cmd.class.name}] #{@description}: Unknown Request type" )
        if cmd.collection.eql?("management") and resp.success
          resp = add_firmware_catalog(resp)
        end

        duration = SknUtils.duration(@_start_time)
        logger.perf "#{self.class.name}##{__method__} Command: #{cmd.class.name.split('::').last}, Returned: #{resp.class.name.split('::').last}, Duration: #{duration}"
        resp
      rescue StandardError => e
        duration = SknUtils.duration(@_start_time)
        logger.warn "#{self.class.name}##{__method__} Failure Request: Provider: #{@description}, klass=#{e.class.name}, cause=#{e.message}, Duration: #{duration}, Backtrace=#{e.backtrace[0..1]}"
        SknFailure.call(self.class.name, "#{e.class.name}::#{e.message}, Duration: #{duration}")
      end

      # SknSuccess or SknFailure
      def process(cmd)
        @_stream.call(cmd.collection, cmd.device_name)
      end

      def add_firmware_catalog(resp)
        SknSuccess.(
            {
                  devices: resp.value[:package],
                scheduled: subscriptions,
                  catalog: firmware_catalog.value[:payload]
            },
            resp.message
        )
      end

      def subscriptions
        @_subscriptions.subscriptions.map(&:to_hash)
      end

      def firmware_catalog
        @_firmwares.call('catalog', 'hash')
      end

      def logger
        Logging.logger['HMIE']
      end

    end # end class

  end
end

