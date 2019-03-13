# File: ./main/homie/events/subscription.rb
#


module Homie
  module Events

    class Subscription
      attr_reader :firmware, :device, :status, :date_requested, :date_completed

      def initialize(firmware:, device:)
        @firmware = firmware
        @device = device
        @status = ""
        @date_requested = Date.today
        @date_completed = nil
      end

      def handle_queue_event?(queue_event)
        false
      end

      def eql?(other)
        other.kind_of?(self.class) &&
          firmware.checksum.eql?(other.firmware.checksum) &&
              device.mac.eql?(other.device.mac)
      end

      def to_hash
        {
            device: device.attributes.map(&:device_hash),
            firmware: firmware.to_hash,
            date_requested: date_requested,
            date_completed: date_completed
        }
      end

    end
  end
end
