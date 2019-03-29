# ##
# File: ./main/services/commands/monitor_config.rb
#
#
# cmd = Services::Commands::MonitorConfig.new(params )
# ##

module Services
  module Commands

    class MonitorConfig

      def initialize(args={})
        @bundle = args
      end

      def valid?
        @bundle.nil? or @bundle.empty? ? false : true
      end

      def value
        @bundle
      end

    end

  end
end
