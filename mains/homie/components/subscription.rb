# File: ./main/homie/component/subscription.rb
#
# This class is serialized to YML via YAML::Store
# - Please do not leave behind references to core objects
# 

module Homie
  module Components

    class Subscription
      attr_reader :device_name, :mac, :filename, :firmware_name, :path,
                  :state, :date_requested, :date_completed, :version, :checksum

      def initialize(firmware:, device:)
        @path = firmware.path
        @firmware_name = firmware.name
        @filename = firmware.filename
        @version  = firmware.version
        @checksum = firmware.checksum
        @device_name = device.name
        @mac = device.attributes.detect{|r| r.name.eql?('$mac')}&.value
        @state = "Waiting"
        @date_requested = time_stamp
        @date_completed = nil
        SknApp.logger.debug "#{self.class.name}.#{__method__} for: #{device_name}:#{firmware_name}"
      end

      def handle_queue_event?(queue_event)
        message_type = queue_event.device_attribute_property_all.value.strip
        message_value = queue_event.value

        rc = true

        if device_name.eql?(queue_event.topic_parts[1]) and @date_completed.blank?

          if queue_event.device_attribute.success and
              ['$online','$state'].include?(queue_event.device_attribute.value) and
                date_completed.blank?

            if ["ready","true"].include?(message_value) and
                  date_completed.blank? and not
                      ['up-to-date', 'disabled'].include?(state)

              parts = queue_event.topic_parts
              SknApp.registry.resolve("device_stream_manager").send_queue_event(
                  Homie::Components::Firmware.new(path,
                    "#{parts[0]}/#{parts[1]}/$implementation/ota/firmware/#{checksum}")
              )
              @state = 'active'
              SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] SEND FIRMWARE(#{@filename}) EVENT"
            end

          else

            case message_type

              when 'checksum'
                if checksum.eql?(message_value)
                  @state = 'up-to-date'
                  @date_completed = time_stamp
                end

              when "ota.firmware"
                @state = 'active'

              when "ota.status"
                if message_value.start_with?("202")
                  @state = 'accepted'
                elsif message_value.start_with?("200")
                  @state = 'success'
                  @date_completed = time_stamp
                elsif message_value.start_with?("304")
                  @state = 'up-to-date'
                  @date_completed = time_stamp
                elsif message_value.start_with?("403")
                  @state = 'disabled'
                  @date_completed = time_stamp
                elsif message_value.start_with?("400")
                  @state = message_value
                elsif message_value.start_with?("500")
                  @state = message_value
                elsif message_value.start_with?("206 ")
                  rc = false
                  @state = 'inprogress'
                  SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Processing!) (#{message_value})"
                end
            end
          end
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Processed) STATE: #{@state}:#{message_type}"
          rc
        elsif device_name.eql?(queue_event.topic_parts[1]) and !@date_completed.blank?
          SknApp.logger.debug "#{self.class.name}.#{__method__} [#{device_name}] (Ignored) STATE: #{@state}:#{message_type}"
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

      def time_stamp
        DateTime.now.strftime("%Y-%b-%d %H:%M")
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
