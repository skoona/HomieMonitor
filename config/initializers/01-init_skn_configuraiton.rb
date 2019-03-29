# ##
# 01-init_configuration.rb
#
# This creates a global constant (and singleton) with a defaulted configuration
# See config/settings.yml, config/settings/*.yml, and config/settings/*.local.yml
# Source: skn_utils.gem lib/skn_utils/configuration.rb
#
class << (SknSetting = SknUtils::Configuration.new( {config_filename: ENV.fetch('RACK_ENV', 'development')} ))
end

if RUBY_PLATFORM == "java"
  if defined?($servlet_context)

    value = java.lang.System.getenv('HM_MQTT_HOST')
    SknSettings.mqtt.host     = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_PORT')
    SknSettings.mqtt.port     = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_USER')
    SknSettings.mqtt.username = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_PASS')
    SknSettings.mqtt.password = value unless value.nil?

    value = java.lang.System.getenv('HM_BASE_TOPICS')
    SknSettings.mqtt.env_base_topics = eval(value) unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_LOG')
    SknSettings.mqtt.debug_log_file = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_SSL_ENABLE_FLAG') # expect 'true'
    SknSettings.mqtt.ssl_enable = eval(value) unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_SSL_CERT_PATH')
    SknSettings.mqtt.ssl_certificate_path = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_SSL_KEY_PATH')
    SknSettings.mqtt.ssl_key_path = value unless value.nil?

    value = java.lang.System.getenv('HM_FIRMWARE_PATH')
    SknSettings.content_service.firmware_path = value unless value.nil?

    value = java.lang.System.getenv('HM_SPIFFS_PATH')
    SknSettings.content_service.spiffs_path   = value unless value.nil?

    value = java.lang.System.getenv('HM_DATA_STORE')
    SknSettings.content_service.data_source.store = value unless value.nil?

    value = java.lang.System.getenv('HM_OTA_TYPE')
    SknSettings.content_service.ota.type = value unless value.nil?

    $stdout.puts("Using Real Environment Values.  HM_MQTT_HOST=#{SknSettings.mqtt.host}:#{SknSettings.mqtt.env_base_topics}")
  end
end
