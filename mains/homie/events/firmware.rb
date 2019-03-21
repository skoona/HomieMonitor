# File: ./main/homie/events/firmware.rb
#


module Homie
  module Events

    class Firmware
      attr_reader :source, :homie_type, :version, :filename, :description

      def initialize(source:, homie_type:, filename:, version:, description:)
        @source      = source.dup
        @description = description
        @filename    = filename
        @version     = version.dup
        @homie_type  = homie_type.dup
        @created     = DateTime.now.strftime("%Y-%b-%d %H:%M")
      end

      def ==(other)
        other.class == self.class && other.internal_state == self.internal_state
      end
      alias_method :eql?, :==

      def internal_state
        self.instance_variables.map { |variable| self.instance_variable_get variable }
      end

      def to_hash
        {
            type: self.class.name.split('::').last,
            description: description,
            source:  source,
            homie_type: homie_type,
            filename: filename,
            version: version,
            created: @created
        }
      end

    end
  end
end
