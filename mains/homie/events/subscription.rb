# File: ./main/homie/events/subscription.rb
#


module Homie
  module Events

    class Subscription
      attr_reader :topic_ary, :device_name, :old_version, :new_version, :filename, :description

      def initialize(topic_array:, device_name:, source:, from:, to:, filename:, description:)
        @topic_ary   = topic_array.dup
        @description = description
        @name        = source.dup
        @device_name = device_name
        @filename    = filename
        @old_version = from.dup
        @new_version = to.dup
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
            topic: topic_ary.join("/"),
            source:  name,
            device_name: device_name,
            filename: filename,
            from: old_version,
            to: new_version,
            created: @created
        }
      end

    end
  end
end
