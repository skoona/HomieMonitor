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
    SknSettings.mqtt.env_base_topics = value unless value.nil?

    value = java.lang.System.getenv('HM_MQTT_LOG')
    SknSettings.mqtt.debug_log_file  = value unless value.nil?

    value = java.lang.System.getenv('HM_FIRMWARE_PATH')
    SknSettings.content_service.firmware_path = value unless value.nil?

    value = java.lang.System.getenv('HM_SPIFFS_PATH')
    SknSettings.content_service.spiffs_path   = value unless value.nil?

    value = java.lang.System.getenv('HM_DATA_STORE')
    SknSettings.content_service.data_source.store = value unless value.nil?

    $stdout.puts("Using Real Environment Values.  HM_MQTT_HOST=#{SknSettings.mqtt.host}")
  end
end

# java.lang.System.getenv(
#     SknSettings.mqtt.host     = java.lang.System.getenv('HM_MQTT_HOST')           if SknSettings.mqtt.host.eql?("some.fqdn.com")
#     SknSettings.mqtt.port     = java.lang.System.getenv('HM_MQTT_PORT')           if SknSettings.mqtt.port == 1883
#     SknSettings.mqtt.username = java.lang.System.getenv('HM_MQTT_USER')           if SknSettings.mqtt.username.eql?("userid")
#     SknSettings.mqtt.password = java.lang.System.getenv('HM_MQTT_PASS')           if SknSettings.mqtt.password.eql?("password")
#     SknSettings.mqtt.env_base_topics = java.lang.System.getenv('HM_BASE_TOPICS')  if SknSettings.mqtt.env_base_topics == [["sknSensors/#", 1], ["homie/#", 1]]
#     SknSettings.mqtt.debug_log_file  = java.lang.System.getenv('HM_MQTT_LOG')     if SknSettings.mqtt.debug_log_file.eql?("/tmp/homieMonitor/paho-debug.log")
#
#     SknSettings.content_service.firmware_path = java.lang.System.getenv('HM_FIRMWARE_PATH')  if SknSettings.content_service.firmware_path.eql?("./content/firmwares/")
#     SknSettings.content_service.spiffs_path   = java.lang.System.getenv('HM_SPIFFS_PATH')    if SknSettings.content_service.spiffs_path.eql?("./content/spiffs/")
#     SknSettings.content_service.data_source.store = java.lang.System.getenv('HM_DATA_STORE') if SknSettings.content_service.data_source.store.eql?("./db/HomieMonitor_store.yml")