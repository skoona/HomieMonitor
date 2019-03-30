# ##
#
# Merge new settings into current and write to development/production.local.yml
# Services::Handlers::Settings
#
#

module Services
  module Handlers

    class Settings

      def self.call(new_settings)
        self.new.call(new_settings)
      end

      def initialize()
        SknApp.logger.debug "#{self.class.name}.#{__method__} "
      end

      def call(new_settings)

        current_settings = SknUtils::DottedHash.new( SknSettings.to_hash )
        current_settings.delete_field(:Packaging)
        current_settings.delete_field(:skn_base)

        current_settings.content_service.demo_mode = new_settings.run_mode.eql?("demo") ? true : false
        current_settings.mqtt.host     = new_settings.mqtt_host
        current_settings.mqtt.port     = new_settings.mqtt_port.to_i
        current_settings.mqtt.username = new_settings.mqtt_username
        current_settings.mqtt.password = new_settings.mqtt_password

        SknApp.settings_paths.each do |path|
          path.write(Psych.dump( current_settings.to_hash ))
        end

        msg = "#{self.class.name}##{__method__} Processed(#{new_settings.run_mode}:#{new_settings.mqtt_host})"
        SknApp.logger.debug msg
        SknSuccess.call( {success: true, status: 202, message: "", payload: {}})
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknFailure.call({success: false, status: 406, message: msg, payload: {}}, msg)
      end

    end # end class
  end
end
