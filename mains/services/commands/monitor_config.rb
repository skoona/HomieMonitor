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

# PARAMS =
# {
#   "run_mode"=>"demo",
#   "ota_type"=>"RFC4648",
#   "datasource_store"=>"",
#   "firmwares_path"=>"",
#   "envbase_topics"=>"",
#   "ssl_enable"=>"1",
#   "mqtt_host"=>"",
#   "mqtt_port"=>"",
#   "mqtt_username"=>"",
#   "mqtt_password"=>"",
#   "ssl_cert_path"=>"",      -- not present if ssl_enable is present and eq 1
#   "ssl_key_path"=>""
# }

#
# :content_service:
#     :demo_mode: false                                       run_mode
# :firmware_path: "./content/firmwares/"                      firmwares_path
# :spiffs_path: "./content/spiffs/"
# :data_source:
#     :store: "./db/HomieMonitor_store.yml"                   datasource_store
# :ota:
#     :type: binary                                           ota_type

# :mqtt:
#   :host: openhabianpi.skoona.net                            mqtt_host
#   :port: 1883                                               mqtt_port
#   :username: openhabian                                     mqtt_username
#   :password: Apache.Tomcat.8                                mqtt_password
#   :env_base_topics:                                         envbase_topics
#   :base_topics:
#     - - sknSensors/#
#         - 0
#     - - homie/#
#         - 0
#   :ssl_enable: false                                        ssl_enable
#   :ssl_certificate_path:                                    ssl_cert_path
#   :ssl_key_path:                                            ssl_key_path
