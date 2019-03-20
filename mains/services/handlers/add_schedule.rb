# ##
#
# Handle Adding a subscription
# Services::Handlers::AddSchedule
#
#

module Services
  module Handlers

    class AddSchedule
      def self.call(device_name, checksum, ota_format)
        self.new.call(device_name, checksum, ota_format)
      end

      def initialize()
        @_provider  = SknApp.registry.resolve("subscriptions_provider")
        @_firmwares = SknApp.registry.resolve("firmware_catalog")
        @_stream    = SknApp.registry.resolve("device_stream_manager")
        SknApp.logger.debug "#{self.class.name}.#{__method__} "
      end

      def call(device_name, checksum, ota_format)

        firmware_obj = @_firmwares.call('find', checksum)
        raise "Firmware not Found" if firmware_obj.nil?
        firmware_obj.value[:ota_format] = ota_format

        device_obj   = @_stream.devices.detect {|rec| rec.name.eql?(device_name.gsub(" ", '')) }
        raise "Device not Found" if device_obj.nil?

        subscription = @_provider.create_subscription(device_obj: device_obj,
                                                      firmware_obj: firmware_obj.value[:payload].first)

        msg = "#{self.class.name}##{__method__} Processed(#{device_name}:#{ota_format})"
        SknApp.logger.debug msg
        SknSuccess.call({success: true, error: "", payload: subscription.to_hash})
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknFailure.call({success: false, error: msg, payload: {}}, msg)
      end

    end # end class
  end
end
