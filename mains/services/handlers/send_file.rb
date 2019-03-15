# ##
#
# Handle Temporary File Response
# Services::Handlers::SendFile
#
# Send in one of two formats: Binary or Base64
# - Need a MD5 Hash
#

module Services
  module Handlers

    class SendFile
      def self.call(response)
        self.new().call(response)
      end

      def initialize()
        @_temp_path = SknSettings.content_service.firmware_path
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      def call(response)
        # content-type => application/pdf
        # content-disposition => inline; filename="Commission-WestBranch-0040.pdf"
        # x-request-id => f599bc98-4f8b-4e32-b296-9c8307ff4eaf
        real, temp = filenames(response)
        IO.binwrite(temp, response.body)
        SknSuccess.call({
            content_type: response['content-type'],
            request_id: response['x-request-id'],
            filename: real,
            content_disposition: response['content-disposition'],
            payload: temp },
            "Source Duration: #{response['x-runtime']} seconds")
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknFailure.("", msg)
      end

      def filenames(rsp)
        real = rsp['content-disposition'].scan(/filename=\"(.+)\"/).flatten.first
        temp = "#{@_temp_path}#{rsp['x-request-id']}.#{real.split('.').last || rsp['content-type'].split('/').last}"
        [real, temp]
      end

    end # end class
  end
end

# Helper to push a firmware-file vai MQTT to our Homie-Device.
# def push_firmware_to_dev(new_firmware)
#   bin_file = File.read(new_firmware.file_path)
#   md5_bin_file = Digest::MD5.hexdigest(bin_file)
#   base_topic = configatron.mqtt.base_topic + mac + '/'
#   client = mqtt_connect
#   sended = FALSE
#   client.publish(base_topic + '$implementation/ota/checksum', md5_bin_file, retain = false)
#   sleep 0.1
#   client.subscribe(base_topic + '$implementation/ota/status')
#   cursor = TTY::Cursor
#   puts ' '
#   client.get do |_topic, message|
#     ms = message
#     ms = message.split(/ /).first.strip if message.include?(' ')
#     if ms == '206'
#       now, ges = message.split(/ /).last.strip.split(/\//).map(&:to_i)
#       actual = (now / ges.to_f * 100).round(0)
#       print cursor.column(1)
#       print "Pushing firmware, #{actual}% done"
#     end
#     if ms == '304'
#       puts '304, file already installed. No action needed. ' + message
#       break
#     end
#     if ms == '403'
#       puts '403, OTA disabled:' + message
#       break
#     end
#     if ms == '400'
#       puts '400, Bad checksum:' + message
#       break
#     end
#     if ms == '202'
#       puts '202, pushing file'
#       client.publish(base_topic + '$implementation/ota/firmware', bin_file, retain = false)
#       sended = TRUE
#     end
#     if ms == '200' && sended
#       puts "\nFile-md5=#{md5_bin_file} installed, device #{name} is rebooting"
#       break
#     end
#   end
# end
# end
#
# # Class represents a pair of a Homie-Device and a firmware running on this device
# class HomiePair
#   attr_reader :hdev, :hfw
#   def initialize(dev, *fw)
#     fw.flatten!
#     @hdev = dev.nil? ? nil : dev
#     @hfw  = fw.empty? ? nil : fw.first
#   end
# end
