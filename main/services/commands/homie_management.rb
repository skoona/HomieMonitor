# ##
# File: ./main/services/commands/homie_management.rb
#
#
# cmd = Services::Commands::HomieManagement
# ##

module Services
  module Commands

    class HomieManagement

      attr_reader :collection, :device_name

      def initialize(device_name: "")
        @collection  = "management"
        @device_name = device_name
      end

      def valid?
        true
      end

    end

  end
end
