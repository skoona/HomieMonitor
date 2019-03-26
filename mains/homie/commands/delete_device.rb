# ##
# File: ./main/services/commands/homie_devices.rb
#
#
# cmd = Services::Commands::DeleteDevice.new(args )
# ##

module Homie
  module Commands

    class DeleteDevice

      def initialize(topic)
        @_topic = topic
      end

      def valid?
        true
      end

      def id
        0
      end

      def topic
        SknSuccess.(@_topic)
      end

      def retain
        true
      end

      def qos
        0
      end

      def value
        ""
      end

    end

  end
end
