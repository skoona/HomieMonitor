# ##
# File: ./main/services/commands/homie_devices.rb
#
#
# cmd = Services::Commands::DeleteDevice.new(device_id )
# ##

module Services
  module Commands

    class DeviceDelete

      def initialize(device_id)
        @device_name = device_id
      end

      def valid?
        !@device_name.nil?
      end

      def value
        @device_name
      end

    end

  end
end
