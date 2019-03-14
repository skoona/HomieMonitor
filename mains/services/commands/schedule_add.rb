# ##
# File: ./mains/services/commands/schedule_delete.rb
#
#
# cmd = Services::Commands::ScheduledFile.new
# {"klass"=>"Device", "name"=>"GuestRoom", "value"=>"Guest Room", "base"=>"sknSensors", "attributes"=>[{"klass"=>"Attribute", "name"=>"$state", "value"=>"ready", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$homie", "value"=>"3.0.1", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$name", "value"=>"Guest Room", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$mac", "value"=>"BC:DD:C2:81:04:72", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$localip", "value"=>"10.100.1.230", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$nodes", "value"=>"motion,temperature,humidity", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$stats", "value"=>"uptime", "properties"=>[{"klass"=>"Property", "name"=>"interval", "value"=>"0", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"signal", "value"=>"32", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"uptime", "value"=>"2275209", "settable"=>false, "attributes"=>[]}]}, {"klass"=>"Attribute", "name"=>"$fw", "value"=>"sknSensors-Rcwl_Dht22", "properties"=>[{"klass"=>"Property", "name"=>"name", "value"=>"sknSensors-Rcwl_Dht22", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"version", "value"=>"0.2.5", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"checksum", "value"=>"b3f61ac429e0d5371aff0e651759be5c", "settable"=>false, "attributes"=>[]}]}, {"klass"=>"Attribute", "name"=>"$implementation", "value"=>"esp8266", "properties"=>[{"klass"=>"Property", "name"=>"config", "value"=>"{\"name\":\"Guest Room\",\"device_id\":\"GuestRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"version", "value"=>"3.0.0", "settable"=>false, "attributes"=>[]}, {"klass"=>"Property", "name"=>"ota.enabled", "value"=>"true", "settable"=>false, "attributes"=>[]}]}], "nodes"=>[{"klass"=>"Node", "name"=>"motion", "value"=>"Humans Present", "properties"=>[{"klass"=>"Property", "name"=>"motion", "value"=>"false", "settable"=>false, "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Motion", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$datatype", "value"=>"boolean", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$unit", "value"=>"s", "properties"=>[]}]}], "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Humans Present", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$type", "value"=>"motion", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$properties", "value"=>"motion", "properties"=>[]}]}, {"klass"=>"Node", "name"=>"temperature", "value"=>"Room Temperature", "properties"=>[{"klass"=>"Property", "name"=>"degrees", "value"=>"73.76", "settable"=>false, "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Degrees", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$datatype", "value"=>"float", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$unit", "value"=>"ºF", "properties"=>[]}]}], "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Room Temperature", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$type", "value"=>"temperature", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$properties", "value"=>"degrees", "properties"=>[]}]}, {"klass"=>"Node", "name"=>"humidity", "value"=>"Room Humidity", "properties"=>[{"klass"=>"Property", "name"=>"percent", "value"=>"35.20", "settable"=>false, "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Percent", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$datatype", "value"=>"float", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$unit", "value"=>"%", "properties"=>[]}]}], "attributes"=>[{"klass"=>"Attribute", "name"=>"$name", "value"=>"Room Humidity", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$type", "value"=>"humidity", "properties"=>[]}, {"klass"=>"Attribute", "name"=>"$properties", "value"=>"percent", "properties"=>[]}]}]}
# ##

module Services
  module Commands

    class ScheduleAdd

      attr_reader :device_name, :checksum

      def initialize(request_params={})
        @device_name  = request_params["name"]
        @checksum  = request_params["name"]

        SknApp.logger.debug "#{self.class.name}.#{__method__} For device: #{@device_name}"
      end

      def valid?
        device_name.is_a?(String) && device_name.size > 1
      end

    end

  end
end
