# ##
#
# Hashes one or all device trees
# Services::Handlers::Stream

module Services
  module Handlers

    class Stream

      def self.call(collection_type="devices", device_name=nil)
        self.new.call(collection_type, device_name)
      end

      def initialize
        @_stream_manager = SknApp.registry.resolve("device_stream_manager")
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      # "device" , device_name | nil for all
      # "broadcasts"
      def call(collection_type, device_name)
        if collection_type.blank? or
            collection_type.eql?("devices") or
              collection_type.eql?("management")
          collect_devices(device_name)

        elsif collection_type.eql?("broadcasts")
          collect_broadcasts

        elsif collection_type.eql?('message_transport')
          message_transport(device_name)

        else
          SknFailure.call("", "Unknown Collection Type Param: #{collection_type}")
        end
      end

      def collect_devices(device_name=nil) # package: [Devices]
        devices = @_stream_manager.content_devices
        if !device_name.blank?
          SknSuccess.call( package: [ devices.value[:package].detect {|device| device_name.eql?(device[:name]) } ].compact )
        else
          devices # SknSuccess/Failure array of hashed device objects
        end
      end

      def collect_broadcasts # package: [{name:, value:}]
        @_stream_manager.content_broadcasts
      end

      def message_transport(queue_event) # returns true|false
        if @_stream_manager.send_queue_event(queue_event)
          SknSuccess.({success: true, status: 200, message: "Sent to #{queue_event.topic.value}"})
        else
          SknFailure.({success: false, status: 404, message: "Add to send_queue failed!"})
        end
      end

    end # end class
  end
end
