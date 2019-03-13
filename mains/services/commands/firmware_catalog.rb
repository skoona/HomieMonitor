# ##
# File: ./main/services/commands/homie_devices.rb
#
#
# cmd = Services::Commands::HomieDevices.new(device_name: nil | 'TheaterIR' )
# ##

module Services
  module Commands

    class FirmwareCatalog

      attr_reader :collection

      def initialize()
        @collection  = []
      end

      def valid?
        true
      end

    end

  end
end
