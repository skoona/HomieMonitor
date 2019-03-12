# File: ./main/homie/events/value_changed.rb
#


module Homie
  module Events

    class ValueChanged
      attr_reader :topic_ary, :name, :old_value, :new_value

      def initialize(topic_array:, source:, from:, to:)
        @topic_ary = topic_array.dup
        @name = source.dup
        @old_value = from.dup
        @new_value = to.dup
      end

      def to_hash
        {
            topic: topic_ary.join("/"),
            source:  name,
            from: old_value,
            to: new_value
        }
      end

    end
  end
end
