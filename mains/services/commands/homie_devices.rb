# ##
# File: ./main/services/commands/homie_devices.rb
#
#
# cmd = Services::Commands::HomieDevices.new(device_name: nil | 'TheaterIR' )
# ##

module Services
  module Commands

    class HomieDevices

      attr_reader :collection, :device_name

      def initialize(device_name: nil)
        @collection  = "devices"
        @device_name = device_name
      end

      def valid?
        true
      end

    end

  end
end
