# ##
# 01-init_configuration.rb
#
# This creates a global constant (and singleton) with a defaulted configuration
# See config/settings.yml, config/settings/*.yml, and config/settings/*.local.yml
# Source: skn_utils.gem lib/skn_utils/configuration.rb
#
class << (SknSetting = SknUtils::Configuration.new( {config_filename: ENV.fetch('RACK_ENV', 'development')} ))
end
