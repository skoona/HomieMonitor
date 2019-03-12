# ##
# 00-init_configurable
#
# Main Business Application

class SknApp
  # define SknApp.config values
  extend Dry::Configurable

  # Enable SknApp.env, SknApp.root, and SknApp.logger with reader: true
  setting(:data_source, "", reader: true)
  setting(:env, ::SknUtils::EnvStringHandler.new( ENV.fetch('RACK_ENV', 'development')), reader: true)
  setting(:root, ::SknUtils::EnvStringHandler.new( Dir.pwd ), reader: true)
  setting(:registry, ::Dry::Container.new, reader: true)
  setting(:homie_provider_thread, "", reader: true)
  setting(:debug_logger, "" , reader: true)
  setting(:logger, "", reader: true)
  setting(:debug, true, reader: true)

  # reader: true, enable SknApp.logger versus SknApp.config.logger; SknApp.config.logger = <is still required to set value laster>
end
