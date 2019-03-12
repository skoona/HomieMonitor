# ##
# File: ./main/services/commands/send_file.rb
#
#
# cmd = Services::Commands::SendFile.new
# ##

module Services
  module Commands

    class SendFile

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
