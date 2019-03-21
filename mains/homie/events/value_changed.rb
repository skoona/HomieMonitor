# File: ./main/homie/events/value_changed.rb
#


module Homie
  module Events

    class ValueChanged
      attr_reader :topic_ary, :name, :old_value, :new_value, :description

      def initialize(topic_array:, source:, from:, to:, description:)
        @topic_ary   = topic_array.dup
        @description = description
        @name        = source.dup
        @old_value   = from.dup
        @new_value   = to.dup
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
            from: old_value,
            to: new_value,
            created: @created
        }
      end

    end
  end
end
