# File: ./main/homie/component/subscription.rb
#


module Homie
  module Components

    class Subscription
      attr_reader :device_name, :mac, :filename, :firmware_name,
                  :state, :date_requested, :date_completed, :version, :checksum

      def initialize(firmware:, device:)
        @firmware_name = firmware.name
        @filename = firmware.filename
        @version  = firmware.version
        @checksum = firmware.checksum
        @device_name = device.name
        @mac = device.attributes.detect{|r| r.name.eql?('$mac')}&.value
        @state = "Waiting"
        @date_requested = Date.today
        @date_completed = nil
        SknApp.logger.debug "#{self.class.name}.#{__method__} for: #{device_name}:#{firmware_name}"
      end

      def handle_queue_event?(queue_event)
        message_type = queue_event.device_attribute_property.value
        if device_name.eql?(queue_event.topic_parts[1])
          case message_type
            when 'checksum'
              if checksum.eql?(queue_event.value)
                @state = 'up-to-date'
                @date_completed = Date.today
              end
            when "/[$online|$state]/"
              if ["ready","true"].include?(queue_event.value)
                #(send firmware) unless @state.eql?('up-to-date')
                @state = 'pending'
                SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] SEND FIRMWARE(#{@filename}) EVENT"
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
                @state = 'up-to-date'
                @date_completed = Date.today
              elsif queue_event.value == "403"
                @state = 'disabled'
              elsif queue_event.value == "400"
                @state = 'error'
              elsif queue_event.value == "500"
                @state = 'error'
              elsif queue_event.value.include?("206 ")
                @state = 'inprogress'
                SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Processing!) (#{queue_event.value})"
              end
          end
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Processed) STATE: #{@state}:#{message_type}"
          true
        else
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Skipped) STATE: #{@state}:#{message_type}"
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

      def ==(other)
        other.class == self.class && other.internal_state == self.internal_state
      end
      alias_method :eql?, :==

      def internal_state
        self.instance_variables.map { |variable| self.instance_variable_get variable }
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
