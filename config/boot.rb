# ##
# File: ./config/boot.rb
# - Initialize Core Application: SknApp
#

# Instantiate Application
begin
  unless defined?(SknApp)
    require_relative 'environment'        # Minimal
  end

  # Load Main Business App
  require_relative '../main/main'

  # initialize MQTT Discover Facilities / keep a reference to thread
  unless SknApp.env.test? or defined?($SKIP_AUTOSTART)
    SknApp.config.homie_provider_thread = SknApp.registry.resolve("device_stream_manager").call()
  end

rescue LoadError, StandardError => ex
  $stderr.puts ex.message
  $stderr.puts ex.backtrace[0..8]
  exit 1
end

