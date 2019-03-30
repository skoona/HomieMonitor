# ##
# File: ./main/services/commands/monitor_config.rb
#
#
# cmd = Services::Commands::MonitorConfig.new(params )
# ##

module Services
  module Commands

    class MonitorConfig

      # {
      #   "run_mode"=>"demo",   || 'production'
      #   "mqtt_host"=>"fqdn",
      #   "mqtt_port"=>"1883",
      #   "mqtt_username"=>"user",
      #   "mqtt_password"=>"pass"
      # }
      def initialize(args={})
        @bundle = SknUtils::DottedHash.new( args )
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
