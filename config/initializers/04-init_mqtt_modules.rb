# ##
# 00-init_mqtt_modules
#
# Configure the MQTT Stream
#
require "./mains/homie/handlers/stream"

module Homie
  module Handlers

    class Stream
      extend Dry::Configurable

      setting(:host, SknSetting.mqtt.host, reader: true)
      setting(:port, SknSetting.mqtt.port, reader: true)
      setting(:client_id, SecureRandom.hex(4), reader: true)
      setting(:username, SknSetting.mqtt.username, reader: true)
      setting(:password, SknSetting.mqtt.password,  reader: true)
      setting(:base_topics, (SknSettings.mqtt.env_base_topics.is_a?(Array) ? SknSettings.mqtt.env_base_topics : SknSetting.mqtt.base_topics), reader: true )
      setting(:debug_log_file, SknSetting.mqtt.debug_log_file, reader: true)
      setting(:ota_type, SknSettings.content_service.ota.type, reader: true)
    end
  end
end
