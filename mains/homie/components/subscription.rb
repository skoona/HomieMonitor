# File: ./main/homie/component/subscription.rb
#


module Homie
  module Components

    class Subscription
      attr_reader :firmware, :device, :device_name, :mac, :filename,
                  :state, :date_requested, :date_completed, :version, :checksum

      def initialize(firmware:, device:)
        @firmware = firmware
        @filename = firmware.filename
        @version  = firmware.version
        @checksum = firmware.checksum
        @device = device
        @device_name = device.name
        @mac = device.attributes.detect{|r| r.name.eql?('$mac')}&.value
        @state = "Waiting"
        @date_requested = Date.today
        @date_completed = nil
        SknApp.logger.debug "#{self.class.name}.#{__method__} for: #{device_name}:#{firmware.name}"
      end

      def handle_queue_event?(queue_event)
        if device_name.eql?(queue_event.topic_parts[1])
          case queue_event.device_attribute_property.value
            when "/[$online|$state]/"
              if ["ready","true"].include?(queue_event.value)
              #send firmware
                @state = 'pending'
                SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] SEND FIRMWARE(#{@filename}) EVENT"
              else
                @state = 'waiting'
              end

            when "/ota\.firmware/"
              @state = 'started'

            when "/ota\.status/"
              if queue_event.value == "202"
                @state = 'accepted'
              elsif queue_event.value == "200"
                @state = 'success'
                @date_completed = Date.today
              elsif queue_event.value == "304"
                @state = 'completed-current'
              elsif queue_event.value == "403"
                @state = 'disabled'
              elsif queue_event.value == "400"
                @state = 'error'
              elsif queue_event.value == "500"
                @state = 'error'
              elsif queue_event.value.include?("206 ")
                @state = 'inprogress'
              else
                @state = 'waiting'
              end
            else
              @state = 'waiting'
          end
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Processed) STATE: #{@state}"
          true
        else
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Skipped) STATE: #{@state}"
          false
        end
        # pending
        #   -- send ota/firmware/checksum -> firmware
        # wait
        #   -- recv ota/firmware/checksum -> MessageBytes=ddd
        #
        # disabled = 403
        # aborted = 400 | 500
        # accepted = 304
        #
        # inprogress = 206 dd/dd
        #
        # aborted = 400 | 500
        # success = 200
      end

      def eql?(other)
        other.kind_of?(self.class) &&
          checksum.eql?(other.checksum) &&
              mac.eql?(other.mac)
      end

      def to_hash
        {
            device_name: device_name,
            firmware_filename: filename,
            version: version,
            firmware_checksum: checksum,
            mac: mac,
            state: state,
            date_requested: date_requested,
            date_completed: date_completed
        }
      end

    end
  end
end
