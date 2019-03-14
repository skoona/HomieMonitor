# ##
# File: ./mains/services/commands/firmware_delete.rb
#
#
# cmd = Services::Commands::ReceiveFile.new
# ##

module Services
  module Commands

    class FirmwareDelete

      attr_reader :filename

      def initialize(request_params)
        @filename  = request_params["filename"]
        SknApp.logger.debug "#{self.class.name}.#{__method__} File: #{@filename}"
      end

      def valid?
        @filename.is_a?(String) || @filename.is_a?(Pathname)
      end

    end

  end
end
