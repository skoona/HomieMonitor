# ##
# File: ./main/services/commands/homie_broadcasts.rb
#
#
# cmd = Services::Commands::HomieBroadcasts.new
# ##

module Services
  module Commands

    class HomieBroadcasts

      attr_reader :collection, :device_name

      def initialize()
        @collection  = "broadcasts"
        @device_name = nil
      end

      def valid?
        true
      end

    end

  end
end
